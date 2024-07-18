//
//  AudioPlayerManager.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/15.
//

import Foundation
import AVFoundation

protocol AudioPlayerManagerDelegate: AnyObject {
    func audioPlayDidFinishPlaying()
}

class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    
    weak var delegate: AudioPlayerManagerDelegate?
    private var audioPlayer: AVAudioPlayer?  //재생 인스턴스
    
    //오디오 재생 메서드
    func startPlaying(url: URL) throws {
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            // 오디오 출력을 스피커로 시도
        } catch {
            throw FileManagerError.sessionError
        }
        
        //오디오 플레이어 인스턴스 생성 및 초기화
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay() //오디오 재생 준비
            audioPlayer?.play() //오디오 플레이
        } catch {
            throw FileManagerError.playError
        }
    }
    
    //오디오 스탑 메서드
    func stopPlaying() {
        audioPlayer?.stop()
    }
    //오디오 일시정지 메서드
    func pausePlaying() {
        audioPlayer?.pause()
    }
    //오디오 다시재생 메서드
    func resumePlaying() {
        audioPlayer?.play()
    }
    
    func updateCurrentTime() -> TimeInterval{
        return audioPlayer?.currentTime ?? 0
    }
    
    //오디오 플레이가 끝났을 때 호출되는 메서드
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.audioPlayDidFinishPlaying()
    }
    
}
