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

    var recordList: [WeightRecored] = []
    
    //그래프가 업데이트 될 때 마다 갱신하고싶기 때문에 viewWillAppear에 선언해준다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRecord()
        updateGraph()
        configureGraph()
    }
    
    //realm을 인스턴스화시켜, 전 데이터를 취득하고 record리스트에 대입하게하고
    //이 때 realm로부터 취득한 데이터를 날짜가 빠른것부터 넣기위해서 sort메소드를 사용함.
    func setRecord() {
        let realm = try! Realm()
        var result =
        Array(realm.objects(WeightRecored.self))
        result.sort(by: { $0.date < $1.date })
        recordList = result
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
}
