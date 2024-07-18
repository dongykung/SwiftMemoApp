//
//  TodoViewModel.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/08.
//

import Foundation

class TodoViewModel: ObservableObject {
    @Published var todoList: [Todo] = []
    @Published var calendarTodoList: [Todo] = []
    @Published var selectedDate: Date = Date()
    private let todoRepository: TodoRepository
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
        fetchTodayTodos(date: Date())
        fetchDateTodos(date: Date())
        print("뷰모델 init")
    }
    
    func fetchTodayTodos(date: Date) {
        todoList = todoRepository.fetchTodos(for: date)
    }
    
    func fetchDateTodos(date: Date) {
        calendarTodoList = todoRepository.fetchTodos(for: date)
    }
    
    func addTodo(title: String, date: Date, detail: String) {
        if todoRepository.saveNewTodo(title, date: date, detail: detail) {
            fetchTodayTodos(date: Date())
            
            if selectedDate.todayBool {
                fetchDateTodos(date: selectedDate)
            }
        }
    }
    
    func updateTodo(todo: Todo) {
        todoRepository.updateTodo()
        if let today = todo.date?.todayBool {
            guard today == true else {
                fetchDateTodos(date: selectedDate)
                return
            }
            fetchTodayTodos(date: Date())
        }
    }
    
    func deleteTodo(at index: Int) {
        let todo = todoList[index]
        todoRepository.deleteTodo(todo: todo)
        todoList.remove(at: index)
        if let index = calendarTodoList.firstIndex(where: { $0.id == todo.id }) {
            calendarTodoList.remove(at: index)
        }
    }
    
    func deleteCalendarTodo(at index: Int) {
        let todo = calendarTodoList[index]
        todoRepository.deleteTodo(todo: todo)
        calendarTodoList.remove(at: index)
        if let index = todoList.firstIndex(where: { $0.id == todo.id }) {
            todoList.remove(at: index)
        }
    }
    
}
