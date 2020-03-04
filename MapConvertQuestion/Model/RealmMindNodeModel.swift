//
//  RealmMindNodeModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/23.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

class MapGroup:Object{
    @objc dynamic var mapId:String = ""
    let realmMindNodeModel = List<RealmMindNodeModel>()
}

class RealmMindNodeModel:Object{
    @objc dynamic var mapId:String = ""
    @objc dynamic var myNodeId:Int = 0
    @objc dynamic var content:String = ""
    @objc dynamic var parentNodeId:Int = 0
    @objc dynamic var nextDate:Int64 = 0
    @objc dynamic var ifSuccessInterval:Int = 1
    let childNodeIdArray = List<MindNodeChildId>()
}

class MindNodeChildId: Object {
    @objc dynamic var MindNodeChildId: Int = 0
}

class RealmMindNodeModelFactory{
    var allNodeData = [RealmMindNodeModel]()
    init(allNodeData:[RealmMindNodeModel]) {
        self.allNodeData = allNodeData
    }
    
    func selectNodeByNodeId(nodeId:Int) -> RealmMindNodeModel{
        let selectedNode:RealmMindNodeModel = self.allNodeData.filter({ $0.myNodeId == nodeId }).first ?? RealmMindNodeModel()
        return selectedNode
    }
}
