//
//  EditorViewController.swift
//  MyDietDiaryApp
//
//  Created by 申民鐡 on 2021/12/30.
//

import Foundation
import UIKit
import RealmSwift

class EditorViewController: UIViewController {
    //Date의 TextField를 변수로 선언한다.
    @IBOutlet weak var inputDateTextField: UITextField!
    //체중의 TextField를 변수로 선언한다.
    @IBOutlet weak var inputWeightTextField: UITextField!
    //보존버튼을 인스턴스화
    @IBOutlet weak var saveButton: UIButton!
    //보존버튼을 누르면 동작이 취해지도록 액션버튼을 만들어준다.
    @IBAction func saveButton(_ sender: UIButton) {
       saveRecorde()
    }
    
    //realm데이터를 선언한것을 인스턴스화하여 저장할것임
    var record = WeightRecored()
    
    
    //datePiker를 이용하여 날짜를 항상 같은 설정으로 할 수 있게 만들어준다.
    var datePiker: UIDatePicker {
        //datePiker를 인스턴스화 시켜준다.
        let datePiker: UIDatePicker = UIDatePicker()
        //데이터 피커모드를 데이터를 지정한다.
        datePiker.datePickerMode = .date
        //데이터피커의 타임존을 현재를 지정한다.
        datePiker.timeZone = .current
        //piker 스타이릉ㄹ wheels로 지정
        datePiker.preferredDatePickerStyle = .wheels
        //locale은 ja-JP는 일본 로케일
        datePiker.locale = Locale(identifier: "ja-JP")
        datePiker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        return datePiker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeightTextField()
        configDateTextField()
        configureSaveButton()
        print("record : \(record)")
        
    }
    
    @objc func didTapDone(){
        view.endEditing(true)
    }

    var toolBar:UIToolbar {
        //toolbarRect의 사이즈를 정의한다.
        let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
        //정의한 사이즈를 toolbar에 추가해준다.
        let toolBar = UIToolbar(frame: toolBarRect)
        //doneitem을 버튼, 타겟, 액션을 추가해준다
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        //toolbar에 doneItem을 []로 셋팅해준다(복수의 아이템들이 들어올 수 있기에)
        toolBar.setItems([doneItem], animated: true)
        //inputweightTextField에 악세서리로 추가해준다.
        return toolBar
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "ja-JP")
        return dateFormatter
    }
    
    @objc func didChangeDate(picker: UIDatePicker) {
        inputDateTextField.text = dateFormatter.string(from: picker.date)
    }
    
    
    func configureWeightTextField(){
        inputWeightTextField.inputAccessoryView = toolBar
    }
    
    func configDateTextField(){
        inputDateTextField.inputView = datePiker
        inputDateTextField.inputAccessoryView = toolBar
        inputDateTextField.text = dateFormatter.string(from: Date())
    }
    
    func configureSaveButton(){
        saveButton.layer.cornerRadius = 5
    }
    
    func saveRecorde(){
        let realm = try! Realm()
        try! realm.write{
            //inputdatetextfield에 데이터가 있고, date를 변환했을때만 데이터갱신
            if let dateText = inputDateTextField.text,
               let date = dateFormatter.date(from: dateText){
                record.date = date
            }
            //inputweighttextfield에 데이터가 있고 weight를 double형으로 변환했을때만 갱신.
            if let weightText = inputWeightTextField.text,
               let weight = Double(weightText){
                record.weight = weight
            }
            //realm에 record를 추가해준다.
            realm.add(record)
        }
        //자동적으로 체중화면을 닫는다.
        dismiss(animated: true)
    }
    
}
