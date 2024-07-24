//
//  TodoView.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/08.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject var todoViewModel: TodoViewModel
    @State private var showModal: Bool = false
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            VStack {
                if todoViewModel.todoList.isEmpty {
                    withAnimation {
                        AdditionalExplanationView()
                    }
                } else {
                    withAnimation {
                        TodoListView(todoList: todoViewModel.todoList) { todo in
                            withAnimation {
                                todoViewModel.updateTodo(todo: todo)
                            }
                        } deleteTodo: { index in
                            withAnimation {
                                todoViewModel.deleteTodo(at: index)
                            }
                        }
                    }
                }
            }
            CreateTodoBtn() {
                showModal = true
            }
        }
        .navigationTitle("Today's Todo \(todoViewModel.todoList.count)")
        .sheet(isPresented: $showModal) {
            CreateTodoModal(
                todoViewModel: todoViewModel,
                showModal: $showModal
            )
        }
    }
}




struct AdditionalExplanationView: View {
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Todo를\n추가해보세요.")
                    .padding(.top, 25)
                    .padding(.leading, 25)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
                Spacer()
            }
            Spacer()
            Image(systemName: "square.and.pencil")
                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                .resizable()
                .scaledToFit()
                .frame(width: 50,height: 50)
            Text("\"Todo를 추가해 보세요.\"")
            Text("\"오늘의 할 일을 추가해 보세요.\"")
            Text("\"계획적인 삶을 살아보세요!\"")
            Spacer()
        }
        .foregroundStyle(.customGray3)
    }
}


struct TodoListView: View {
    var todoList: [Todo]
    var inComplete: [Todo] {
        get {
            todoList.filter { $0.isCompleted == false }
        }
    }
    var completed: [Todo] {
        get {
            todoList.filter { $0.isCompleted == true }
        }
    }
    var todoClick: (Todo) -> Void
    var deleteTodo: (Int) -> Void
    var body: some View {
        List {
            Section("InComplete") {
                ForEach(inComplete) { todo in
                    TodoItemView(todo: todo, todoClick: todoClick)
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        let todo = inComplete[index]
                        if let deleteIndex = todoList.firstIndex(where: { $0.id  == todo.id }) {
                            deleteTodo(deleteIndex)
                        }
                        
                    }
                })
            }
            
            Section("Completed") {
                ForEach(completed) { todo in
                    TodoItemView(todo: todo, todoClick: todoClick)
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        let todo = completed[index]
                        if let deleteIndex = todoList.firstIndex(where: { $0.id  == todo.id }) {
                            deleteTodo(deleteIndex)
                        }
                        
                    }
                })
            }
            
        }
    }
}

struct TodoItemView: View {
    var todo: Todo
    var todoClick: (Todo) -> Void
    var body: some View {
        
        HStack(alignment: .center) {
            Button {
                todo.isCompleted = !todo.isCompleted
                todoClick(todo)
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle" : "circle")
            }
            VStack(alignment: .leading) {
                Text(todo.title ?? "Not Title")
                    .strikethrough(todo.isCompleted)
                HStack {
                    Text(todo.date?.formattedDay ?? "")
                    Text(todo.date?.formattedTime ?? "")
                }
            }
        }
    }
}

struct CreateTodoBtn: View {
    let btnAction: () -> Void
    var body: some View {
        Button {
            btnAction()
        } label: {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.circle)
                .padding(.trailing, 20)
                .padding(.bottom, 15)
        }
    }
}

struct TodoListView_PreView: PreviewProvider {
    static var previews: some View {
       
        @StateObject var todoViewModel = TodoViewModel()
        NavigationStack {
            TodoView(todoViewModel: todoViewModel)
        }
    }
}
