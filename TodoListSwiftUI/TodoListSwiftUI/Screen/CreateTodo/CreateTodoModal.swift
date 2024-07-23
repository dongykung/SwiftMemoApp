//
//  ModalTodo.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/09.
//

import SwiftUI


struct CreateTodoModal: View {
    @StateObject private var createTodoViewModel: CreateTodoViewModel = CreateTodoViewModel()
    @ObservedObject var todoViewModel: TodoViewModel
    @Binding var showModal: Bool
    var body: some View {
        VStack {
            CustomTopBar(
                backBtnAction: {
                    showModal = false
                },
                actionBtnAction: {
                    todoViewModel.addTodo(
                        title: createTodoViewModel.title,
                        date: createTodoViewModel.date,
                        detail: createTodoViewModel.detail)
                    showModal = false
                },
                actionBtnType: .complete
            )
            .padding(.top, 15)
            
            CreateTodoExplainView()
                .padding(.top, 20)
            
            CreateTodoTitleView(title: $createTodoViewModel.title)
                .padding(.horizontal, 20)
                .padding(.top, 15)
            
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
            
            CreateTodoTimeView(date: $createTodoViewModel.date)
                .padding(.vertical, 10)
            
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
            
            CreateTodoDateView(date: $createTodoViewModel.date)
                .padding(.top, 15)
            Spacer()
        }
    }
}

private struct CreateTodoExplainView: View {
    
    var body: some View {
        HStack {
            Text("To do list를 \n추가해 보세요.📑")
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}


private struct CreateTodoTitleView: View {
    @Binding var title: String
    
    var body: some View {
        TextField("Todo 제목을 입력해주세요.",text: $title)
    }
}



private struct CreateTodoTimeView: View {
    @Binding var date: Date
    var body: some View {
        VStack {
            DatePicker("",selection: $date,displayedComponents: [.hourAndMinute])
                .labelsHidden()
                .datePickerStyle(.wheel)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
    }
}

private struct CreateTodoDateView: View {
    @Binding var date: Date
    @State var isVisibleCalendar: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("날짜")
                    .font(.title2)
                Spacer()
            }
            Spacer().frame(height: 12)
            HStack {
                Button {
                    isVisibleCalendar = true
                } label: {
                    Text("\(date.formattedDay)")
                        .font(.system(size: 20,weight: .medium))
                }
                .popover(isPresented: $isVisibleCalendar) {
                    DatePicker(
                        "",
                        selection: $date,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .onChange(of: date) { (_, _) in
                        isVisibleCalendar = false
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
  
    CreateTodoModal(
        todoViewModel: TodoViewModel(), showModal: .constant(false)
    )
}
