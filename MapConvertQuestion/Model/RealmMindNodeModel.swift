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
    @objc dynamic var nodePrimaryKey:String = NSUUID().uuidString
    @objc dynamic var mapId:String = ""
    @objc dynamic var myNodeId:Int = 0
    @objc dynamic var content:String = ""
    @objc dynamic var parentNodeId:Int = 0
    @objc dynamic var parentNodePrimaryKey:String = ""
    @objc dynamic var nextDate:Int64 = Date().millisecondsSince1970
    @objc dynamic var ifSuccessInterval:Int = 1
    @objc dynamic var isAnswer:Bool = true
    let childNodeIdArray = List<MindNodeChildId>()

    override static func primaryKey() -> String? {
        return "nodePrimaryKey"
    }
}

extension RealmMindNodeModel {
    public static func ==(l:RealmMindNodeModel, r:RealmMindNodeModel) -> Bool {
        return l.nodePrimaryKey == r.nodePrimaryKey
    }
}

class MindNodeChildId: Object {
    @objc dynamic var MindNodeChildId: Int = 0
}

class RealmMindNodeModelFactory{
    
    var allNodeData = [RealmMindNodeModel]()
    init(allNodeData:[RealmMindNodeModel]) {
        self.allNodeData = allNodeData
    }
    
//    func selectNodeByNodeId(nodeId:Int) -> RealmMindNodeModel{
//        let selectedNode:RealmMindNodeModel = self.allNodeData.filter({ $0.myNodeId == nodeId }).first ?? RealmMindNodeModel()
//        return selectedNode
//    }
    
//    func getAnswerNodeArray(childNodeIdList:List<MindNodeChildId>) -> [RealmMindNodeModel]{
//        var localAnswerNodeArray = [RealmMindNodeModel]()
//        for answerNodeId in childNodeIdList {
//            let nodeId = answerNodeId.MindNodeChildId
//            let answerNode = self.selectNodeByNodeId(nodeId: nodeId)
//            localAnswerNodeArray.append(answerNode)
//        }
//        return localAnswerNodeArray
//    }
    
//    func calculateNextDateWhenCorrect(question:RealmMindNodeModel) -> LearningIntervalStruct{
//        var learningIntervalStruct = LearningIntervalStruct(ifSuccessNextInterval: 0, nextLearningDate: 0)
//        let nextInterval = question.ifSuccessInterval
//        switch nextInterval {
//            case Interval.first.rawValue:
//                learningIntervalStruct.ifSuccessNextInterval = Interval.second.rawValue
//                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.second.rawValue, to: Date())!.millisecondsSince1970
//            case Interval.second.rawValue:
//                learningIntervalStruct.ifSuccessNextInterval = Interval.third.rawValue
//                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.third.rawValue, to: Date())!.millisecondsSince1970
//            case Interval.third.rawValue:
//                learningIntervalStruct.ifSuccessNextInterval = Interval.fourth.rawValue
//                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.fourth.rawValue, to: Date())!.millisecondsSince1970
//            case Interval.fourth.rawValue:
//                learningIntervalStruct.ifSuccessNextInterval = Interval.fifth.rawValue
//                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.fifth.rawValue, to: Date())!.millisecondsSince1970
//            case Interval.fifth.rawValue:
//                learningIntervalStruct.ifSuccessNextInterval = Interval.sixth.rawValue
//                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.sixth.rawValue, to: Date())!.millisecondsSince1970
//            case Interval.sixth.rawValue:
//                learningIntervalStruct.ifSuccessNextInterval = Interval.sixth.rawValue
//                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.sixth.rawValue, to: Date())!.millisecondsSince1970
//            case 0:
//                learningIntervalStruct.ifSuccessNextInterval = 1
//                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.first.rawValue, to: Date())!.millisecondsSince1970
//            default:
//                print("interval error")
//        }
//        return learningIntervalStruct
//    }
}
