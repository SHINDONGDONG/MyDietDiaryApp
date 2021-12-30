//
//  CalenderViewController.swift
//  MyDietDiaryApp
//
//  Created by 申民鐡 on 2021/12/27.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var calenarView: FSCalendar!
    
    @IBAction func addButtonNV(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "EditorViewController", bundle: nil)
        guard let editorViewController =
                storyboard.instantiateViewController(withIdentifier: "EditorViewController") as?
                EditorViewController else {return}
        present(editorViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //캘린더의 설정메소드
        configureCalendar()
        //버튼의 설정메소드
        configureButton()
    }
    
    func configureCalendar(){
        //header 일시 포맷을 변경
        calenarView.appearance.headerDateFormat = "yyyy年MM月dd日"
        //요일과 금일의 색지정
        calenarView.appearance.todayColor = .orange
        calenarView.appearance.headerTitleColor = .orange
        calenarView.appearance.weekdayTextColor = .black
        
        //요일 표시내용을 변경
        calenarView.calendarWeekdayView.weekdayLabels[0].text = "日"
        calenarView.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calenarView.calendarWeekdayView.weekdayLabels[1].text = "月"
        calenarView.calendarWeekdayView.weekdayLabels[2].text = "火"
        calenarView.calendarWeekdayView.weekdayLabels[3].text = "水"
        calenarView.calendarWeekdayView.weekdayLabels[4].text = "木"
        calenarView.calendarWeekdayView.weekdayLabels[5].text = "金"
        calenarView.calendarWeekdayView.weekdayLabels[6].text = "土"
        calenarView.calendarWeekdayView.weekdayLabels[6].textColor = .blue
    }
    
    //addbutton의 설정 메소드를 작성한다.
    func configureButton(){
        //addbutton의 cornerRadius를 add.bounds.width /2 로 나누어주어 동그랗게 만든다
        addButton.layer.cornerRadius  = addButton.bounds.width / 2
    }
    
    
}
