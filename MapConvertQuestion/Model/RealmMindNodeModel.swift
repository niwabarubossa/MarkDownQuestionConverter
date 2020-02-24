//
//  RealmMindNodeModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/23.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMindNodeModel:Object{
    @objc dynamic var myNodeId:Int = 0
    @objc dynamic var content:String = ""
    @objc dynamic var parentNodeId:Int = 0
    @objc dynamic var childNodeIdArray:[Int] = [0000]
}
