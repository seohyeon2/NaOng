//
//  NotificationListViewModel.swift
//  NaOng
//
//  Created by seohyeon park on 2023/08/12.
//

import Foundation
import UserNotifications
import CoreData
import Combine

@MainActor
class NotificationListViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var groupedToDoItems: [String : [ToDo]] = [:]

    private var fetchedResultsController: NSFetchedResultsController<ToDo> = NSFetchedResultsController()
    private var cancellables: Set<AnyCancellable> = []
    private let viewContext: NSManagedObjectContext
    private let localNotificationManager: LocalNotificationManager
    
    init(viewContext: NSManagedObjectContext, localNotificationManager: LocalNotificationManager) {
        self.viewContext = viewContext
        self.localNotificationManager = localNotificationManager
        
        super.init()
        fetchedResultsController.delegate = self
        
        if let fetchedToDoItems = fetchTodoItems(with: "isNotificationVisible == %@", argumentArray: [true]) {
            replaceGroupedToDoItems(with: fetchedToDoItems)
        }
    }

    func bind() {
        localNotificationManager.deliveredNotificationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] notifications in
                notifications.forEach { [weak self] notification in
                    let id = notification.request.identifier
                    self?.modifyToDoForDisplayOnNotificationView(id: id)
                }
                
                if let fetchedToDoItems = self?.fetchTodoItems(with: "isNotificationVisible == %@", argumentArray: [true]) {
                    self?.replaceGroupedToDoItems(with: fetchedToDoItems)
                }
            }
            .store(in: &cancellables)
    }
    
    func clearDeliveredNotification() {
        localNotificationManager.removeAllDeliveredNotification()
        localNotificationManager.postRemovedEvent()
    }

    private func modifyToDoForDisplayOnNotificationView(id: String) {
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        
        do {
            let toDoItems = try viewContext.fetch(fetchRequest)
            if let toDoItem = toDoItems.first,
                toDoItem.isNotificationVisible == false {
                toDoItem.isNotificationVisible = true
                try toDoItem.save(viewContext: viewContext)
            }
        } catch {
            print("Error: \(error)")
        }
    }

    private func fetchTodoItems(with format: String, argumentArray: [Any]?) -> [ToDo]? {
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: format, argumentArray: argumentArray)
        
        let sortDescriptor = NSSortDescriptor(keyPath: \ToDo.alarmDate, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            try fetchedResultsController.performFetch()
            guard let fetchedItems = fetchedResultsController.fetchedObjects else {
                return nil
            }

            return fetchedItems
            
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func replaceGroupedToDoItems(with toDoItems: [ToDo]?) {
        guard let toDoItems = toDoItems else { return }
        if toDoItems.isEmpty { return }
        
        groupedToDoItems = Dictionary(grouping: toDoItems, by: {$0.alarmDate ?? Date().getFormatDate()})
    }
}
