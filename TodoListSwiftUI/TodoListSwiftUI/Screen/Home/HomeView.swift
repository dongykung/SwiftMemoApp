//
//  HomeView.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/11.
//

import SwiftUI

struct HomeView: View {
    
    
    @StateObject private var todoViewModel = TodoViewModel()
    
    @StateObject private var voiceViewModel: VoiceRecorderViewModel = VoiceRecorderViewModel()
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationStack {
                TodoView(todoViewModel: todoViewModel)
            }
            .tabItem { Label(
                title: { Text("Todo") },
                icon: { Image(systemName: "doc.text.fill") }
            ) }
            .tag(0)
            
            NavigationStack {
                CalendarTodoView(todoViewModel: todoViewModel)
            }
            .tabItem { Label(
                title: { Text("Calendar") },
                icon: { Image(systemName: "calendar") }
            ) }
            .tag(1)
            
            NavigationStack {
                VoiceRecorderView(voiceViewModel: voiceViewModel)
            }
            .tabItem { Label(
                title: { Text("Voice") },
                icon: { Image(systemName: "calendar") }
            ) }
            .tag(2)
            
        }
        
    }
}

//#Preview {
//    HomeView()
//}
