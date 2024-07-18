//
//  RecordManager.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/15.
//

import Foundation
import AVFoundation

enum FileManagerError: Error {
    case sessionError
    case deleteError
    case recordError
    case playError
    case fileInfoError
    case fileTimeError
}

class RecordManager: NSObject {
    
    private var audioRecorder: AVAudioRecorder? //녹음 인스턴스
    private(set) var recordings: [Recording] = []  //녹음 목록
    
    
    override init() {
        super.init()
        fetchAllRecording()
    }
    
    //녹음 시작 메서드
    func startRecording(_ count: Int) throws {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            throw FileManagerError.sessionError
        }
        //파일 저장을 위한 파일 이름
        let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(count)")
        //녹음 셋팅 딕셔너리
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            //AVAudioRecorder 인스턴스 생성 및 초기화
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            //녹음 준비
            audioRecorder?.prepareToRecord()
            //녹음 시작
            audioRecorder?.record()
            
        } catch {
            throw FileManagerError.recordError
        }
    }
    
    
    //녹음 종료 메서드
    func stopRecording() -> Recording {
        audioRecorder?.stop()
        let url = audioRecorder!.url
        let (createDate, duration) = getFileInfo(for: url)
        return Recording(fileURL: url, createdDate: createDate, duration: duration)
    }
    
    
    //모든 녹음 기록을 가져와서 데이터화 시키고 배열에 추가작업
    func fetchAllRecording() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for file in files {
                let (createData, duration) = getFileInfo(for: file)
                recordings.append(Recording(fileURL: file, createdDate: createData, duration: duration))
            }
        } catch {
            print("녹음 기록 가져오기 실패")
        }
    }
    
    //파일에 대한 정보를 가져오는 메서드(생성 날짜와, 재생 시간을 가져옴)
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = FileManager.default
        var creationDate: Date?
        var duration: TimeInterval?
        
        if let attributes = try? fileManager.attributesOfItem(atPath: url.path) as [FileAttributeKey: Any], let date = attributes[.creationDate] as? Date {
            creationDate = date
        }
        
        if let audioPlayer = try? AVAudioPlayer(contentsOf: url) {
            duration = audioPlayer.duration
        }
        
        return (creationDate, duration)
    }
    
    //URL을 받아 삭제하는 메서드
    func removeSelectedVoiceRecord(_ record: URL) throws {
        do {
            try FileManager.default.removeItem(at: record)
        } catch {
            throw FileManagerError.deleteError
        }
    }
    
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //호출 시 뷰모델에서 현재 리코딩 목록 얻을 수 있음
    func getRecordingList() -> [Recording] {
        return recordings
    }
    
    
    
    //녹음 재생
    
}
