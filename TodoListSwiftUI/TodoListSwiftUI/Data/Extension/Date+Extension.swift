//
//  Date+Extension.swift
//  TodoListSwiftUI
//
//  Created by 김동경 on 2024/07/08.
//

import Foundation

extension Date {
    //오후 3시 25분 식으로 문자열 반환하기 위한 extension
    var formattedTime: String {
        let formatter = DateFormatter()  //데이터 포맷터
        formatter.locale = Locale(identifier: "ko_KR") //포맷터 지역 - 한국
        formatter.dateFormat = "a hh:mm"    //데이터 형식
        return formatter.string(from: self) //포맷터의 문자열 반환
    }
    
    //데이터 날짜가 오늘이면 "오늘" 아니면 날짜 문자열 리턴하기위한 extension
    var formattedDay: String {
        let now = Date() //현재 날짜
        let calendar = Calendar.current //캘린더를 현재로 설정
        
        let nowStartOfDay = calendar.startOfDay(for: now) //오늘날짜
        let dateStartOfDay = calendar.startOfDay(for: self) //포맷터 날짜
        
        //날짜가 얼마나 차이나는지
        let numOfDayDifference = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day
        
        if numOfDayDifference == 0 {
            return "오늘" //0이면 오늘임
        } else {
            //그게 아니라면 포맷해서 날짜 출력
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
    }
    
    //입력받은 데이트가 오늘인지 판별
    var todayBool: Bool {
        let now = Date() //현재 날짜
        let calendar = Calendar.current //캘린더를 현재로 설정
        
        let nowStartOfDay = calendar.startOfDay(for: now) //오늘날짜
        let dateStartOfDay = calendar.startOfDay(for: self) //포맷터 날짜
        
        //날짜가 얼마나 차이나는지
        let numOfDayDifference = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day
        
        if numOfDayDifference == 0 {
            return true
        } else {
            return false
        }
    }
    
    var formattedVoiceRecorderTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.M.d"
        
        return formatter.string(from: self)
    }
    
   
}
