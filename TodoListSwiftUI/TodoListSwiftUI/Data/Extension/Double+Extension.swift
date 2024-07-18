//
//  Double+Extension.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/12.
//

import Foundation


extension Double {
    // 05: 12초 이런식으로
    var formattedTimeInterval: String {
        let totalSeconds = Int(self)
        let second = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        
        return String(format: "%02d:%02d", minutes, second)
    }
}
