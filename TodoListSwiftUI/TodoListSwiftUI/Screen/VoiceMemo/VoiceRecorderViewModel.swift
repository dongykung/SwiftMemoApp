//
//  VoiceRecorderViewModel.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/12.
//

import Foundation


class VoiceRecorderViewModel: ObservableObject, AudioPlayerManagerDelegate {
    private let recordManager: RecordManager = RecordManager()
    private let audioManager: AudioPlayerManager = AudioPlayerManager()
    //음성메모 삭제할 때 나타나는 Alert의 값
    @Published var isDisplayRemoveVoiceRecorderAlert: Bool = false
    //파일을 가져오거나 실패할 때 Alert 띄우기 위한 값
    @Published var isDisplayAlert: Bool = false
    //에러 알림창 메시지 값
    @Published var alertMessage: String = ""
    
    //현재 녹음 중?
    @Published var isRecording: Bool = false
    //현재 플레잉 중인지?
    @Published var isPlaying: Bool = false
    //지금 정지상태인지?
    @Published var isPaused: Bool = false
    //얼마나 플레이 되었는지
    @Published var playedTime: TimeInterval = 0
    //프로그래스 바 타이머
    private var progressTimer: Timer?
    
    //녹음 파일들
    var recordedFiles: [Recording] = []
    
    //현재 선택된 음성메모 파일
    @Published var selectedRecoredFile: Recording?
    
    init() {
        recordedFiles = recordManager.getRecordingList()
        self.audioManager.delegate = self
    }
    
    func voiceRecordItemClick(_ recordedFile: Recording) {
        if selectedRecoredFile != recordedFile {
            stopPlaying()
            selectedRecoredFile = recordedFile
        }
    }
    
    func removeBtnTapped() {
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecoredFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        do {
            try recordManager.removeSelectedVoiceRecord(fileToRemove.fileURL)
            recordedFiles.remove(at: indexToRemove)
            selectedRecoredFile = nil
            stopPlaying()
            displayAlert(message: "선택 음성메모 파일을 삭제했습니다.")
        } catch {
            displayAlert(message: "선택 음성메모 파일 삭제 중 오류 발생.")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecorderAlert = isDisplay
    }
    
    private func setErrorAlertMessage(_ message: String) {
        alertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayAlert = isDisplay
    }
    
    private func displayAlert(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
    
}

//MARK: 음성메모 녹음 관련
extension VoiceRecorderViewModel {
    func recordBtnTapped() {
        selectedRecoredFile = nil
        if isPlaying {
            stopPlaying()
            do {
                try recordManager.startRecording(recordedFiles.count + 1)
                self.isRecording = true
            } catch {
                displayAlert(message: "음성 녹음에 실패하였습니다.")
            }
        }
        else if isRecording {
            recordedFiles.append(recordManager.stopRecording())
            self.isRecording = false
        } else {
            do {
                try recordManager.startRecording(recordedFiles.count + 1)
                self.isRecording = true
            } catch {
                displayAlert(message: "음성 녹음에 실패하였습니다.")
            }
        }
    }
}

//MARK: 음성메모 재생 관련
extension VoiceRecorderViewModel {
    
    
    //재생이 끝났을 때 호출되는 메서드
    func audioPlayDidFinishPlaying() {
        print("잘 호출")
        self.isPlaying = false
        self.isPaused = false
    }
    
    func startPlaying(_ recordingURL: URL) {
        do {
            try audioManager.startPlaying(url: recordingURL)
            self.isPlaying = true
            self.isPaused = false
            self.progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                self.updateCurrentTime()
            })
        } catch {
            displayAlert(message: "음성메모 재생 오류")
        }
    }
    
    func stopPlaying() {
        audioManager.stopPlaying()
        self.isPlaying = false
        self.isPaused = false
        self.playedTime = 0
        self.progressTimer?.invalidate()
    }
    
    func pausePlaying() {
        audioManager.pausePlaying()
        self.isPaused = true
    }
    
    func resumePlaying() {
        audioManager.resumePlaying()
        self.isPaused = false
    }
    
    func updateCurrentTime() {
        self.playedTime = audioManager.updateCurrentTime()
    }
    
}


