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
//     let mindNodeShared = RealmMindNodeAccessor.sharedInstance
    static let sharedInstance = RealmMindNodeAccessor()
    private init() {
    }
    
    func getNodeByMapIdGroup(mapId:String) -> [RealmMindNodeModel] {
        let answerArray = self.getMapGroupAnswer(mapId:mapId)
        var questionArray = [RealmMindNodeModel]()
        for answerNode in answerArray {
            let questionNode = self.searchNodeByPrimaryKey(primaryKey: answerNode.parentNodePrimaryKey)
            questionArray.append(questionNode)
        }
        return questionArray
    }
    
    func getMapGroupAnswer(mapId:String) -> [RealmMindNodeModel]{
        let realm = try! Realm()
        let answerArray = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId).filter("isAnswer == %@",true)
        var returnAnswerArray = [RealmMindNodeModel]()
        for answerNode in answerArray {
            returnAnswerArray.append(answerNode)
        }
        return returnAnswerArray
    }
    
    func getTodayAnswer() -> Results<RealmMindNodeModel> {
        let realm = try! Realm()
        let todayEnd = LetGroup.todayEndMili
        let results = realm.objects(RealmMindNodeModel.self).filter("nextDate BETWEEN {0, \(todayEnd)}").filter("isAnswer == %@",true).sorted(byKeyPath: "ifSuccessInterval", ascending: false).sorted(byKeyPath: "nextDate", ascending: true)
        return results
    }
    
    func getNodeByParentNodeId(parentNodeId:String) -> RealmMindNodeModel {
        let realm = try! Realm()
        let todayEnd = LetGroup.todayEndMili
        if let result = realm.objects(RealmMindNodeModel.self).filter("parentNodeId == %@",parentNodeId).first{
            return result
        }
        return RealmMindNodeModel()
    }

    
    func getToDoQuestion() -> [RealmMindNodeModel] {
        let answerNodeArray = self.getTodayAnswer()
        var questionArray = [RealmMindNodeModel]()
        var alreadyExist = [String]()
        for answerNode in answerNodeArray {
            let question:RealmMindNodeModel = self.getNodeByMapIdAndNodeId(mapId:answerNode.mapId,nodeId: answerNode.parentNodeId)
            if question.myNodeId != question.parentNodeId {
                if alreadyExist.contains(question.nodePrimaryKey) == false{
                    questionArray.append(question)
                    alreadyExist.append(question.nodePrimaryKey)
                }
            }
        }
        return questionArray
    }
    
    func getNodeByMapIdAndNodeId(mapId:String,nodeId:Int) -> RealmMindNodeModel{
        let realm = try! Realm()
         let node:RealmMindNodeModel = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId).filter("myNodeId == %@", nodeId).first ?? RealmMindNodeModel()
         return node
    }
    
    func getNodeByNodeIdAndMapId(question:RealmMindNodeModel,nodeId: Int) -> RealmMindNodeModel{
        let realm = try! Realm()
        if let searchResult = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", question.mapId).filter("myNodeId == %@",nodeId).first {
            return searchResult
        }
        return RealmMindNodeModel()
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
    
    func searchNodeByPrimaryKey(primaryKey:String) -> RealmMindNodeModel{
        let realm = try! Realm()
        if let searchResult:RealmMindNodeModel = realm.objects(RealmMindNodeModel.self).filter("nodePrimaryKey == %@", primaryKey).first {
            return searchResult
        }
        return RealmMindNodeModel()
    }

    
    func createMindNode(realmDataArray: [[String: Any]],mapId: String){
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            let mapGroup = MapGroup()
            mapGroup.mapId = mapId
            for item in realmDataArray.enumerated() {
                let node = RealmMindNodeModel(value: item.element)
                mapGroup.realmMindNodeModel.append(node)
            }
            try! realm.write {
                realm.add(mapGroup)
                print("成功だよ", mapGroup)
            }
        } catch {
            print("error",error)
        }
    }
    
    
}

extension RealmMindNodeAccessor{
    func getAllMapGroup() -> Results<MapGroup> {
        let realm = try! Realm()
        let results = realm.objects(MapGroup.self)
        return results
    }
    
    func getAllTitle() -> [Dictionary<String,String>]{
        let allMapIdArray = self.getAllMapGroup()
        var allTitleAndMapIdArray = [Dictionary<String,String>]()
        for item in allMapIdArray {
            let node = self.getNodeByMapIdAndNodeId(mapId: item.mapId, nodeId: 0)
            let data:Dictionary<String,String> = [
                "mapId": item.mapId,
                "title": node.content
            ]
            allTitleAndMapIdArray.append(data)
        }
        return allTitleAndMapIdArray
    }

}
