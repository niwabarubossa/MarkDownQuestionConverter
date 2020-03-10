//
//  UserModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/10.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

class User:Object{
    @objc dynamic var uuid:String = ""
    @objc dynamic var totalCharactersAmount:Int64 = 0
    @objc dynamic var totalAnswerTimes:Int64 = 0
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
