//
//  ToDoItemAddView.swift
//  NaOng
//
//  Created by seohyeon park on 2023/07/06.
//

import SwiftUI

struct TimeToDoItemAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject private var toDoItemAddViewModel: ToDoItemAddViewModel
    
    init(toDoItemAddViewModel: ToDoItemAddViewModel) {
        self.toDoItemAddViewModel = toDoItemAddViewModel
    }
    
    var body: some View {
        VStack() {
            Button {
                dismiss()
            } label: {
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(Color("primary"))
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 60))
            
            ToDoViewFactory.makeToDoTitle(
                title: "할 일 추가하기",
                fontName: "Binggrae-Bold",
                fontSize: 30
            )
            .frame(width: UIScreen.main.bounds.width - 60,alignment: .leading)
            
            ScrollView {
                VStack(spacing: 10) {
                    ToDoViewFactory.makeToDoMoldView(
                        content: ToDoViewFactory.makeToDoTextEditor(
                            title: "할 일 내용",
                            text: $toDoItemAddViewModel.content),
                        height: 200
                    )
                    
                    ToDoViewFactory.makeToDoMoldView(
                        content: ToDoViewFactory.makeToDoToggle(
                            isOn: $toDoItemAddViewModel.isRepeat,
                            title: "반복 여부")
                    )
                    
                    ToDoViewFactory.makeToDoMoldView(
                        content:
                            HStack {
                                ToDoViewFactory.makeToDoTitle(title: "알림 타입")
                                    .frame(width: (UIScreen.main.bounds.width - 90) / 2, alignment: .leading)
                                
                                Spacer()
                                
                                Text("시간")
                                    .font(.custom("Binggrae", size: 15))
                                    .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                                    .background(Color(UIColor.systemGray4))
                                    .cornerRadius(10)
                                
                            }
                            .frame(width: (UIScreen.main.bounds.width - 80))
                    )
                    
                    ToDoViewFactory.makeToDoMoldView(
                        content: ToDoViewFactory.makeToDoDatePicker(
                            selection: $toDoItemAddViewModel.alarmTime,
                            title: "알림 날짜",
                            displayedComponent: .date)
                    )
                    
                    ToDoViewFactory.makeToDoMoldView(
                        content: ToDoViewFactory.makeAlarmTimeView(
                            selection: $toDoItemAddViewModel.alarmTime,
                            title: "알림 시간",
                            displayedComponent: .hourAndMinute)
                    )
                    
                    Button {
                        if toDoItemAddViewModel.addEditToDo() {
                            toDoItemAddViewModel.addLocation()
                            dismiss()
                        }
                    } label: {
                        ToDoViewFactory.makeToDoMoldView(
                            content: ToDoViewFactory.makeToDoTitle(
                                title: "완료")
                            ,background: Color("primary")
                        )
                    }
                    .padding()
                    .alert(isPresented: $toDoItemAddViewModel.showErrorAlert) {
                        Alert(
                            title: Text(toDoItemAddViewModel.errorTitle),
                            message: Text(toDoItemAddViewModel.errorMessage),
                            dismissButton: .default(Text("확인"))
                        )
                    }
                }
            }
        }
    }
}
