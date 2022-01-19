        //
//  WeightRecored.swift
//  MyDietDiaryApp
//
//  Created by 申民鐡 on 2022/01/04.
//

import Foundation
import RealmSwift

class WeightRecored: Object {
    override class func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var weight: Double = 0.0
    
}
