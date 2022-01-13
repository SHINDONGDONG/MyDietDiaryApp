//
//  Date+Extension.swift
//  MyDietDiaryApp
//
//  Created by 申民鐡 on 2022/01/13.
//

import Foundation

extension Date {
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale = Locale(identifier: "Ja-JP")
        return calendar
    }
    
    //년월일,시분초를 픽스해온다 dateCompnents
    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil,
               hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        var comp = DateComponents()
        comp.year = year ?? calendar.component(.year, from: self)
        comp.month = month ?? calendar.component(.month, from: self)
        comp.day = day ?? calendar.component(.day, from: self)
        comp.hour = hour ?? calendar.component(.hour, from: self)
        comp.minute = minute ?? calendar.component(.minute, from: self)
        comp.second = second ?? calendar.component(.second, from: self)
        return calendar.date(from: comp)!
    }
    
    //fixed를 이용하여 특정의 시간 분 초를 모두 0으로 초기화시켰다.
    //다른날짜를 비교할 때 동일한 날짜인지아닌지 판별까능
    var zeroclock: Date {
        return fixed(hour: 0, minute: 0, second: 0)
    }
}
