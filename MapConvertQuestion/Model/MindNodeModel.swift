//
//  MindNodeModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

struct MindNode{
    var myNodeId:Int
    var content:String
    var parentNodeId:Int
    var childNodeIdArray:[Int]
    init(myNodeId:Int,content:String,parentNodeId:Int,childNodeIdArray:[Int]){
        self.myNodeId = myNodeId
        self.content = content
        self.parentNodeId = parentNodeId
        self.childNodeIdArray = childNodeIdArray
    }
}
