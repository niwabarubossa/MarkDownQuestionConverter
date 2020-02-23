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
    dynamic var myNodeId:Int = 0
    dynamic var content:String = ""
    dynamic var parentNodeId:Int = 0
    dynamic var childNodeIdArray:[Int] = [0000]
}
