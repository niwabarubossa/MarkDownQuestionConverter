//
//  RealmMindNodeAccessor.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/19.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMindNodeAccessor {
    static let sharedInstance = RealmMindNodeAccessor()
    private init() {
    }
    
    func getNodeByMapIdGroup(mapId:String) -> Results<RealmMindNodeModel> {
        let realm = try! Realm()
        let results = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId)
        return results
    }
    
    func getTodayAnswer() -> Results<RealmMindNodeModel> {
        let realm = try! Realm()
        let todayEnd = LetGroup.todayEndMili
        let results = realm.objects(RealmMindNodeModel.self).filter("nextDate BETWEEN {0, \(todayEnd)}").filter("isAnswer == %@",true).sorted(byKeyPath: "ifSuccessInterval", ascending: false).sorted(byKeyPath: "nextDate", ascending: true)
        return results
    }
    
    func getNodeByMapIdAndNodeId(mapId:String,nodeId:Int) -> RealmMindNodeModel{
        let realm = try! Realm()
         let node:RealmMindNodeModel = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId).filter("myNodeId == %@", nodeId).first ?? RealmMindNodeModel()
         return node
    }

    func updateNode(updateKeyValueArray:[String:Any],updateNode:RealmMindNodeModel){
        let realm = try! Realm()
        try! realm.write {
            for (key, value) in updateKeyValueArray {
                updateNode.setValue(value,forKey: key)
            }
        }
    }
    
    func searchByPrimaryKey(node:RealmMindNodeModel) -> RealmMindNodeModel{
        let realm = try! Realm()
        if let searchResult:RealmMindNodeModel = realm.objects(RealmMindNodeModel.self).filter("nodePrimaryKey == %@", node.nodePrimaryKey).first {
            return searchResult
        }
        return RealmMindNodeModel()
    }
}
