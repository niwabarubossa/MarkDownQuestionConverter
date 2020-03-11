//
//  QuestionLogModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/10.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

class QuestionLog:Object{
    @objc dynamic var logId:String = NSUUID().uuidString
    @objc dynamic var charactersAmount:Int = 0
    @objc dynamic var date:Date = Date()
    @objc dynamic var mapId:String = ""
    @objc dynamic var questionNodeId:String = ""
    @objc dynamic var thinkingTime:Double = 0.0
    @objc dynamic var isCorrect:Bool = true
    //場所も追加したい
    override static func primaryKey() -> String? {
        return "logId"
    }
}
