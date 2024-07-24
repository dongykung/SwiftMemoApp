//
//  VoiceRecorderView.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/12.
//

import SwiftUI

struct VoiceRecorderView: View {
    
    @ObservedObject var voiceViewModel: VoiceRecorderViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                if voiceViewModel.recordedFiles.isEmpty {
                    AnnouncemenetView()
                } else {
                    VoiceRecorderListView(voiceViewModel: voiceViewModel)
                }
            }
            
            VoiceCreateBtn(voiceViewModel: voiceViewModel)
        }
        .alert(
            "선택된 음성 메모를 삭제하겠습니까?",
            isPresented: $voiceViewModel.isDisplayRemoveVoiceRecorderAlert
        ) {
            Button("삭제", role:.destructive) {
                voiceViewModel.removeSelectedVoiceRecord()
            }
            Button("취소", role:.cancel) {}
        }
        .alert(voiceViewModel.alertMessage,
               isPresented: $voiceViewModel.isDisplayAlert) {
            Button("확인", role:.cancel) {}
        }
               .sheet(isPresented: $voiceViewModel.setRecordTitleModal){
                   SetRecordTextModal(recordModalVisible:$voiceViewModel.setRecordTitleModal,
                                      voiceViewModel: voiceViewModel)
                   .presentationDetents([.fraction(0.15)])
               }
    }
}



private struct AnnouncemenetView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
            
            Spacer()
                .frame(height: 180)
            
            Image(systemName: "pencil")
                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
            Text("음성 메모가 없습니다.")
            Text("하단의 녹음 버튼을 눌러 음성메모를 저장해보세요.")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(.customGray2)
    }
}

private struct VoiceRecorderListView: View {
    @ObservedObject private var voiceViewModel: VoiceRecorderViewModel
    init(voiceViewModel: VoiceRecorderViewModel) {
        self.voiceViewModel = voiceViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(.customGray2)
                    .frame(height: 1)
                
                ForEach(voiceViewModel.recordedFiles) { recordedFile in
                    VoiceRecorderCellView(voiceViewModel: voiceViewModel, recordedFile: recordedFile)
                }
            }
        }
    }
}

private struct VoiceRecorderCellView: View {
    @ObservedObject private var voiceViewModel: VoiceRecorderViewModel
    
    private var recordedFile:Recording
    private var progressBarValue: Float {
        if voiceViewModel.selectedRecoredFile == recordedFile && (voiceViewModel.isPlaying || voiceViewModel.isPaused) {
            return Float(voiceViewModel.playedTime) / Float(recordedFile.duration ?? 1)
        } else {
            return 0
        }
    }
    
    init(
        voiceViewModel: VoiceRecorderViewModel,
        recordedFile: Recording
    ) {
        self.voiceViewModel = voiceViewModel
        self.recordedFile = recordedFile
    }
    
    fileprivate var body: some View {
        VStack {
            Button {
                voiceViewModel.voiceRecordItemClick(recordedFile)
            } label: {
                VStack {
                    HStack {
                        Text(recordedFile.fileURL.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        if let creationDate = recordedFile.createdDate {
                            Text(creationDate.formattedVoiceRecorderTime)
                                .font(.system(size: 14))
                                .foregroundStyle(.customGray3)
                            
                            Spacer()
                            
                            if let duration = recordedFile.duration {
                                Text(duration.formattedTimeInterval)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.customGray3)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            if voiceViewModel.selectedRecoredFile == recordedFile {
                VStack {
                    //프로그래스 바
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.customGray2)
                        
                        Spacer()
                        
                        if let duration = recordedFile.duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.customGray2)
                        }
                    }
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            if voiceViewModel.isPaused {
                                voiceViewModel.resumePlaying()
                            } else {
                                voiceViewModel.startPlaying(recordedFile.fileURL)
                            }
                        }, label: {
                            Image(systemName: "play.fill")
                                .foregroundStyle(.black)
                        })
                        Spacer()
                            .frame(width: 10)
                        
                        Button(action: {
                            if voiceViewModel.isPlaying {
                                voiceViewModel.pausePlaying()
                            }
                        }, label: {
                            Image(systemName: "pause")
                                .foregroundStyle(.black)
                        })
                        Spacer()
                        Button(action: {
                            voiceViewModel.removeBtnTapped()
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.black)
                                .frame(width: 30, height: 30)
                        })
                    }
                }
                .padding(.horizontal, 20)
            }
            Rectangle()
                .fill(.customGray2)
                .frame(height: 1)
        }
    }
}


private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.customGray2)
                
                Rectangle()
                    .fill(.black)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
            
        }
    }
}

private struct VoiceCreateBtn: View {
    @ObservedObject var voiceViewModel: VoiceRecorderViewModel
    
    
    fileprivate var body: some View {
        VStack(alignment: .center) {
            HStack {
                if voiceViewModel.isRecording {
                    Text("\(voiceViewModel.recordPlayedTime.formattedTimeInterval)")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.trailing, 20)
                        .animation(.easeIn, value: voiceViewModel.isRecording)
                }
            }
            
            HStack {
                Button {
                    withAnimation {
                        voiceViewModel.recordBtnTapped()
                    }
                } label: {
                    Image(systemName: "mic.fill")
                        .font(.title.weight(.semibold))
                        .foregroundStyle(voiceViewModel.isRecordPause ? .green : .red)
                        .padding()
                        .clipShape(.circle)
                        .padding(.bottom, 15)
                }
                if voiceViewModel.isRecording {
                    Button {
                        withAnimation {
                            voiceViewModel.saveRecordBtnTapped()
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.title.weight(.semibold))
                            .padding()
                            .clipShape(.circle)
                            .padding(.bottom, 15)
                    }
                }
            }
        }
    }
}


