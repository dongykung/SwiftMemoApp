//
//  SetRecordTextModal.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/24.
//

import SwiftUI

struct SetRecordTextModal: View {
    @Binding var recordModalVisible: Bool
    @ObservedObject var voiceViewModel: VoiceRecorderViewModel
    @State var recordTitle: String = ""
    var body: some View {
        VStack {
            HStack {
                Text("녹음 파일 제목을 입력하세요")
                    .font(.title3)
                    .padding(.leading,12)
                Spacer()
            }
            TextField("녹음 파일 제목을 입력하세요.",text: $recordTitle)
                .cornerRadius(8.0)
                .padding(.horizontal,12)
                .padding(.vertical,6)
        }
        HStack {
            Spacer()
            Button("저장") {
                voiceViewModel.endRecord(recordTitle)
                recordModalVisible = false
            }
            Spacer()
            Button("취소") {
              recordModalVisible = false
            }
            Spacer()
        }
        .font(.title3)
    }
    
}

#Preview {
    SetRecordTextModal(recordModalVisible: .constant(false),voiceViewModel: VoiceRecorderViewModel())
}
