//
//  TodoRepository.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/08.
//

import Foundation
import CoreData

//Todo에 관한 데이터를 관리하는 저장소
class TodoRepository {
    /// 코어 데이터에 접근하기 위한 NSManagedObjectContext
    private let viewContext: NSManagedObjectContext
    
    static let shared: TodoRepository = TodoRepository(viewContext: DataController.shared.viewContext)
    
    /// 초기화 함수
    init(viewContext: NSManagedObjectContext) {
        //외부에서 NSManagedObjectContext를 주입받아 사용
        self.viewContext = viewContext
    }
    
    /// 새로운 Todo모델을 코어데이터에 저장하는 함수
    func saveNewTodo(
        _ title: String,
        date: Date,
        detail: String
    ) -> Bool {
        //Todo모델에 들어갈 데이터를 받아와 Todo인스턴스에 데이터를 담는 과정
        let todoItem = Todo(context: viewContext)
        todoItem.id = UUID().uuidString
        todoItem.title = title
        todoItem.date = date
        todoItem.detail = detail
        todoItem.isCompleted = false    //Todo 새로 추가이므로 완료 데이터는 항상 false
        
        do {
            try viewContext.save()  //코어 데이터에 모델 젖아
            return true
        } catch {   //실패 시 false 리턴
            print("Failed to save New To Do Item: \(error.localizedDescription)")
            return false
        }
    }
    
    /// 코어 데이터의 데이터를 쿼리를 작성하여 가져오는 함수 (파라미터로 날짜 데이터 타입 받음)
    /// 반환 타입으로 Todo 데이터 모델이 담겨있는 배열
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
    
    /// 투두 데이터가 변경 되었을 때 실행되는 함수
    func updateTodo() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to update Todo item: \(error.localizedDescription)")
        }
    }
    
    /// 투두 데이터가 삭제되었을 때 실행되는 함수
    func deleteTodo(todo: Todo) {
        viewContext.delete(todo)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete Todo item: \(error.localizedDescription)")
        }
    }
}
