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
    var myNodePrimaryKey:String
    var content:String
    var parentNodeId:Int
    var childNodeIdArray:[Int]
    var parentNodePrimaryKey:String
    init(myNodeId:Int,myNodePrimaryKey:String,content:String,parentNodeId:Int,childNodeIdArray:[Int],parentNodePrimaryKey:String){
        self.myNodeId = myNodeId
        self.myNodePrimaryKey = myNodePrimaryKey
        self.content = content
        self.parentNodeId = parentNodeId
        self.childNodeIdArray = childNodeIdArray
        self.parentNodePrimaryKey = parentNodePrimaryKey
    }
}
