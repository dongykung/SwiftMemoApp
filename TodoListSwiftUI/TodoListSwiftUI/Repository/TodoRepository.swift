//
//  TodoRepository.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/08.
//

import Foundation
import CoreData

class TodoRepository {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func saveNewTodo(
        _ title: String,
        date: Date,
        detail: String
    ) -> Bool {
        let todoItem = Todo(context: viewContext)
        todoItem.id = UUID().uuidString
        todoItem.title = title
        todoItem.date = date
        todoItem.detail = detail
        todoItem.isCompleted = false
        
        do {
            try viewContext.save()
            return true
        } catch {
            print("Failed to save New To Do Item: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchTodos(for date: Date) -> [Todo] {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.entity = Todo.entity()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let datePredicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.predicate = datePredicate
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed To Fetch Todo Items: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func updateTodo() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to update Todo item: \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(todo: Todo) {
        viewContext.delete(todo)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete Todo item: \(error.localizedDescription)")
        }
    }
}
