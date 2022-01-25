//
//  GraphViewController.swift
//  MyDietDiaryApp
//
//  Created by 申民鐡 on 2021/12/27.
//

import UIKit
import Charts
import RealmSwift

class GraphViewController: UIViewController {
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    var recordList: [WeightRecored] = []
    
    //datePickder 메소드를 만들어준다.
    var datePicker: UIDatePicker {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ja-JP")
        return datePicker
    }
    
    //dateFormatter를 만들어준다.
    var dateFormatter: DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "ja-JP")
        return dateFormatter
    }
    
    //그래프가 업데이트 될 때 마다 갱신하고싶기 때문에 viewWillAppear에 선언해준다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRecord()
        updateGraph()
        configureGraph()
        configureTextField()
    }
    
    //realm을 인스턴스화시켜, 전 데이터를 취득하고 record리스트에 대입하게하고
    //이 때 realm로부터 취득한 데이터를 날짜가 빠른것부터 넣기위해서 sort메소드를 사용함.
    func setRecord() {
        let realm = try! Realm()
        var result =
        Array(realm.objects(WeightRecored.self))
        result.sort(by: { $0.date < $1.date })
        recordList = result
        
        //개시일과 종료일의 텍스트필드의 텍스트를 취득한다
        if let startDateText = startDateTextField.text,
           let endDateText = endDateTextField.text,
        //startDate에 dateformatter로 뽑은 startdatetext를 넣어준다.
           let startDate = dateFormatter.date(from: startDateText),
           let endDate = dateFormatter.date(from: endDateText) {
            var filterRecord = Array(realm.objects(WeightRecored.self)
                                        .filter("date BETWEEN { %@, %@ }", startDate, endDate))
            //sort
            filterRecord.sort(by: { $0.date > $1.date })
            recordList = filterRecord
        }
    }
    
    //그래프를 나타낸다
    func updateGraph(){
        var entry = [ChartDataEntry]()
        //레코드리스트에 접속하게되는데 이넘게이트로 인덱스번호를 인수로 취득할 수 있게 됨
        recordList.enumerated().forEach({index, record in
            //cahrtDataEntry의 x는 차트x y는 차트y
            let date = ChartDataEntry(x: Double(index), y: record.weight)
            entry.append(date)
        })
        
        //date 표의 체중기준을 세움
        let dataSet = LineChartDataSet(entries: entry, label: "体重")
        //linechartdate를 인스턴스화 시켜 graphview에 대입한다.
        graphView.data = LineChartData(dataSet: dataSet)
        //그래프를 갱신하는 datachaned, datasetchanged를 선언해준다.
        graphView.data?.notifyDataChanged()
        graphView.notifyDataSetChanged()
    }
    //그래프 x가 커브로 보일 수 있게 조정하기
    func configureGraph() {
        graphView.xAxis.labelPosition = .bottom
        //방금전 만든 x축의 formatter 클래스를 인스턴스화 시킨다.
        let titleFormatter = GraphDateTitleFormatter()
        //graphdatetitleformatter에 넘길 날짜들을 datelist로 담아준다.
        let dateList = recordList.map({ $0.date })
        //datelist를 graphdatetitleformatter에 담아준다.
        titleFormatter.dateList = dateList
        //graphview의 xAixs의 valueFormatter를 titleFormatter로 대체하면 된다.
        graphView.xAxis.valueFormatter = titleFormatter
        
    }
    
    //done 툴바를 변수로 선언해준다.
    var toolBar: UIToolbar {
        //툴바의 사이즈
        let toolBarRec = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
        //툴바의 프레임을 넣어주고
        let toolBar = UIToolbar(frame: toolBarRec)
        //done을 uibarbuttonitem에 넣어준다.
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        //툴바에 아이템을 셋팅해주고 리턴
        toolBar.setItems([doneItem], animated: true)
        return toolBar
    }
    //done을 클릭하면 키보드가 닫힌다.
    @objc func didTapDone() {
        //키보드가 닫히는순간 record와 updategraph를 업데이트 해줘야하므로 아래의 두 메소드를.. 넣자
        setRecord()
        updateGraph()
        view.endEditing(true)
    }
    
    //Textfield를 표현할 수 있는 메소드를 만들어준다.
    func configureTextField() {
        //start데이터의 픽커를 만들어줌
        let startDatePicker = datePicker
        //end데이터의 픽커를 만들어줌
        let endDatePicker = datePicker
        //today는 오늘을 넣어주고
        let today = Date()
        //1개월전의 데이터를 pastMonth에 넣어준다. Calendar.current.date의 month를 지정 -1
        let pastMonth = Calendar.current.date(byAdding: .month, value: -1 ,to: today)!
        //startdatepicker.date에 pastmonth를
        startDatePicker.date = pastMonth
        //enddatepickder.date에 today를 대입하여 1개월을 조회할 수 있게 만들어준다.
        endDatePicker.date = today
        //inputview도 그에맞게 넣어주면됨
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        //textfield에서도 그에맞게 dateFormatt을 하여 string으로 보여줘야한다.
        startDateTextField.text = dateFormatter.string(from: pastMonth)
        endDateTextField.text = dateFormatter.string(from: today)
        startDateTextField.inputAccessoryView = toolBar
        endDateTextField.inputAccessoryView = toolBar
        
        //func configureTextField()임
        //datepicker를 addtarget으로 start,end모두 추가해준다.
        startDatePicker.addTarget(self, action: #selector(didChangeStartDate), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(didChangeEndDate), for: .valueChanged)
    }
    
    //startDateTextfield 텍스트에 데이터 포맷으로 스트링값을 넣어준다
    @objc func didChangeStartDate(picker: UIDatePicker) {
        startDateTextField.text = dateFormatter.string(from: picker.date)
    }
    
    @objc func didChangeEndDate(picker: UIDatePicker) {
        endDateTextField.text = dateFormatter.string(from: picker.date)
    }
}
