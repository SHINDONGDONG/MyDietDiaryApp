//
//  GraphDateTitleFormatter.swift
//  MyDietDiaryApp
//
//  Created by 申民鐡 on 2022/01/24.
//

import Foundation
import Charts

class GraphDateTitleFormatter: IAxisValueFormatter {
    var dateList: [Date] = []
    
    //stringforvalue는 x축의 라벨에 표시할 수 있는 메소드가된다.
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        //value인수를 int형태로 바꾸어준다.
        let index = Int(value)
        //datelist 요소수가 index보다 크지않으면 공백을 리턴해준다.
        guard dateList.count > index else { return ""}
        //datelist에서 해당 인덱스의 데이터를 취득하여 targetDate에 대입해준다.
        let targetDate = dateList[index]
        //날짜를 스트링으로 변경시키기위해
        let formatter = DateFormatter()
        //String으로 바꾼 형식은 월/일 형식으로 바꿈.
        let dateFormatString = "M/d"
        formatter.dateFormat = dateFormatString
        //return으로 targetDate에 들어와있는 int형태의 데이터들을 string으로 바꾸어준다.
        return formatter.string(from: targetDate)
    }
    
    
}
