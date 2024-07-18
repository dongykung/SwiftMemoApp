//
//  CreateTodoViewModel.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/09.
//

import Foundation

class CreateTodoViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var date: Date = Date()
    @Published var detail: String = ""
}
