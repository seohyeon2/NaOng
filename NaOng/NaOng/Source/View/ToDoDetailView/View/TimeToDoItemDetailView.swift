//
//  TimeToDoItemDetailView.swift
//  NaOng
//
//  Created by seohyeon park on 2023/07/31.
//

import SwiftUI

struct TimeToDoItemDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject private var toDoItemDetailViewModel: ToDoItemDetailViewModel
    
    init(toDoItemDetailViewModel: ToDoItemDetailViewModel) {
        self.toDoItemDetailViewModel = toDoItemDetailViewModel
    }
    
    var body: some View {
        VStack(spacing: 15) {
            ToDoViewFactory.makeToDoDetailVerticalContentView(
                title: "할일 내용",
                content:
                    ScrollView {
                        Text(toDoItemDetailViewModel.toDoItem.content ?? "")
                            .font(.custom("Binggrae", size: 15))
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }
                    .frame(height: 140)
                    .background(Color("tertiary"))
            )
            
            ToDoViewFactory.makeToDoDetailHorizontalContentView(
                title: "반복 여부",
                content: toDoItemDetailViewModel.getRepeatedStatus()
            )
            
            ToDoViewFactory.makeToDoDetailHorizontalContentView(
                title: "알림 타입",
                content: "시간"
            )

            ToDoViewFactory.makeToDoDetailHorizontalContentView(
                title: "시작 날짜",
                content: toDoItemDetailViewModel.toDoItem.alarmTime?.getFormatDate("yyyy-MM-dd-E") ?? "알 수 없음"
            )

            ToDoViewFactory.makeToDoDetailHorizontalContentView(
                title: "알림 시간",
                content: toDoItemDetailViewModel.toDoItem.alarmTime?.getFormatDate("HH:mm") ?? "알 수 없음"
            )

            DoneListView(doneListViewModel: DoneListViewModel(viewContext: viewContext, toDoItem: toDoItemDetailViewModel.toDoItem))
        }
        .padding()
        .navigationBarItems(
            trailing:
                Button(action: {
                    toDoItemDetailViewModel.isShowingToDoItemAddView = true
                }, label: {
                    Text("수정")
                })
                .frame(width: 50, height: 50)
                .fullScreenCover(isPresented: $toDoItemDetailViewModel.isShowingToDoItemAddView) {
                    let viewModel = ToDoItemAddViewModel(
                        viewContext: viewContext,
                        localNotificationManager: toDoItemDetailViewModel.localNotificationManager,
                        toDoItem: toDoItemDetailViewModel.toDoItem,
                        alarmType: toDoItemDetailViewModel.toDoItem.alarmType ?? "시간")
                    TimeToDoItemAddView(toDoItemAddViewModel: viewModel)
                }
        )
    }
}
