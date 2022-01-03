//
//  EditorViewController.swift
//  MyDietDiaryApp
//
//  Created by 申民鐡 on 2021/12/30.
//

import Foundation
import UIKit

class EditorViewController: UIViewController {
    //체중의 TextField를 변수로 선언한다.
    @IBOutlet weak var inputWeightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeightTextField()
    }
    
    @objc func didTapDone(){
        view.endEditing(true)
    }
    
    func configureWeightTextField(){
        //toolbarRect의 사이즈를 정의한다.
        let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
        //정의한 사이즈를 toolbar에 추가해준다.
        let toolBar = UIToolbar(frame: toolBarRect)
        //doneitem을 버튼, 타겟, 액션을 추가해준다
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        //toolbar에 doneItem을 []로 셋팅해준다(복수의 아이템들이 들어올 수 있기에)
        toolBar.setItems([doneItem], animated: true)
        //inputweightTextField에 악세서리로 추가해준다.
        inputWeightTextField.inputAccessoryView = toolBar
    }
}
