//
//  CalendarTodoView.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/11.
//

import SwiftUI

struct CalendarTodoView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    var body: some View {
        VStack {
            DatePicker(
                "",
                selection: $todoViewModel.selectedDate,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.graphical)
            .onChange(of: todoViewModel.selectedDate) {
                todoViewModel.fetchDateTodos(date: todoViewModel.selectedDate)
            }
            
            TodoListView(todoList: todoViewModel.calendarTodoList) { todo in
                withAnimation {
                    todoViewModel.updateTodo(todo: todo)
                }
            } deleteTodo: { index in
                withAnimation {
                    todoViewModel.deleteCalendarTodo(at: index)
                }
            }
        }
    }
}

#Preview {
    CalendarTodoView(todoViewModel: TodoViewModel())
}
