//
//  ToDoListItemView.swift
//  NaOng
//
//  Created by seohyeon park on 2023/06/25.
//

import SwiftUI

struct ToDoItemView: View {
    @ObservedObject private var toDoItemViewModel: ToDoItemViewModel

    init(toDoItemViewModel: ToDoItemViewModel) {
        self.toDoItemViewModel = toDoItemViewModel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                toDoItemViewModel.didTapDoneButton()
            } label: {
                Image(toDoItemViewModel.markerName)
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            
            Text(toDoItemViewModel.toDoItem.content ?? "")
                .font(.custom("Binggrae", size: 15))
                .strikethrough(toDoItemViewModel.toDoItem.isDone)
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            
            Spacer()
            
            Text(toDoItemViewModel.getDistinguishedAlarmInformation())
                .font(.custom("Binggrae", size: 12))
                .foregroundStyle(.black)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
        }
        .frame(width: (UIScreen.main.bounds.width - 60), height: 80, alignment: .topLeading)
        .background(Color(toDoItemViewModel.backgroundColor))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 3)
        )
        .padding(10)
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)) { _ in
            toDoItemViewModel.setMarkerName()
            toDoItemViewModel.setBackgroundColor()
        }
    }
}
