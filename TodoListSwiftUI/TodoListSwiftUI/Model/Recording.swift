//
//  Recording.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/15.
//

import Foundation

struct Recording: Identifiable, Equatable {
    var id: UUID = UUID()
    let fileURL: URL
    let createdDate: Date?
    let duration: TimeInterval?
}
