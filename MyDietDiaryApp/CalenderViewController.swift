//
//  CalenderViewController.swift
//  MyDietDiaryApp
//
//  Created by 申民鐡 on 2021/12/27.
//

import UIKit
import FSCalendar
import RealmSwift

class CalenderViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var calenarView: FSCalendar!
    @IBAction func addButtonNV(_ sender: UIButton) {
        transitionToDeitorView()
    }
    
    var recordList: [WeightRecored] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //캘린더의 설정메소드
        configureCalendar()
        //버튼의 설정메소드
        configureButton()
        //FSCalendardatasource 유효화
        calenarView.dataSource = self
        //FSCalendarDelegate 유효화
        calenarView.delegate = self
    }
    //표시될때마다 실행한다
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getrecord()
        calenarView.reloadData()
        
    }
    
    func transitionToDeitorView(with record: WeightRecored? = nil){
        let storyboard = UIStoryboard.init(name: "EditorViewController", bundle: nil)
        guard let editorViewController =
                storyboard.instantiateViewController(withIdentifier: "EditorViewController") as?
                EditorViewController else {return}
        //이동시킬 화면에 record의 데이터를 담아준다
        if let record = record {
            editorViewController.record = record
        }
        present(editorViewController, animated: true)
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
    
    func getrecord(){
        let realm = try! Realm()
        recordList = Array(realm.objects(WeightRecored.self))
    }
    
}

extension CalenderViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //recordList에 격납되어있는 데이터프로퍼티를 추출하고싶어 맵 메소드로 데이터를 추출하여 datelist에 대입.
        let dateList = recordList.map({$0.date.zeroclock})
        //contains를 사용하여 datelist에 파라메터인 date와 같은데이터가 존재하면 true로 대입된다.
        let isEqualDate = dateList.contains(date.zeroclock)
        //isEqualdate가 true이면 1개를 아니면 0개를 리턴해준다.
        return isEqualDate ? 1 : 0
    }
}

extension CalenderViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //날짜를 선택했을 때 select가 되지않도록 해준다.(색상이변경됨)
        calendar.deselect(date)
        //배열에 대해서 임의의 값을 조건을 취득할 때 first where메소드를 사용한다. $0는 배열의 요소의 데이터를 말하는것이며 인수 date와 비교하여 날짜가같으면 등록 아니면 미등록 처리한다.
        guard let record = recordList.first(where: {$0.date.zeroclock == date.zeroclock}) else {return}
        transitionToDeitorView(with: record)
         
    }
}
