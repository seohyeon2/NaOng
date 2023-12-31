//
//  ToDoItemDetailViewModel.swift
//  NaOng
//
//  Created by seohyeon park on 2023/07/31.
//

import Foundation
import CoreData

class ToDoItemDetailViewModel: ObservableObject {
    @Published var isShowingToDoItemAddView: Bool = false
    
    private(set) var toDoItem: ToDo
    private let viewContext: NSManagedObjectContext
    private(set) var localNotificationManager: LocalNotificationManager
    
    init(viewContext: NSManagedObjectContext, toDoItem: ToDo, localNotificationManager: LocalNotificationManager) {
        self.viewContext = viewContext
        self.toDoItem = toDoItem
        self.localNotificationManager = localNotificationManager
    }
    
    func getRepeatedStatus() -> String {
        switch toDoItem.isRepeat {
        case true:
            return "⭕️"
        default:
            return "❌"
        }
    }
}

