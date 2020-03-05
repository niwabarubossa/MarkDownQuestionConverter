//
//  QuestionModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

protocol QuestionModelDelegate: class {
    func didGetMapQuestion(question:Results<RealmMindNodeModel>)
}

class QuestionModel {
    weak var delegate: QuestionModelDelegate?
    var allNodeData = [RealmMindNodeModel]()
    
    func getMapQuestion(mapId:String){
        let realm = try! Realm()
        let allQuestionNodeArray = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId)
        self.delegate?.didGetMapQuestion(question: allQuestionNodeArray)
    }
    
    func updateMapQuestion(learningIntervalStruct:LearningIntervalStruct,focusNode:RealmMindNodeModel){
        let realm = try! Realm()
        let focusNode = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", focusNode.mapId).filter("myNodeId == %@", focusNode.myNodeId).first

        try! realm.write {
        focusNode?.setValue(learningIntervalStruct.ifSuccessNextInterval, forKey: "ifSuccessInterval")
        
            focusNode?.setValue(learningIntervalStruct.nextLearningDate, forKey: "nextDate")
        }
    }
    
    func selectNodeByNodeId(nodeId:Int) -> RealmMindNodeModel{
        let selectedNode:RealmMindNodeModel = self.allNodeData.filter({ $0.myNodeId == nodeId }).first ?? RealmMindNodeModel()
        return selectedNode
    }
    
    func getAnswerNodeArray(childNodeIdList:List<MindNodeChildId>) -> [RealmMindNodeModel]{
        var localAnswerNodeArray = [RealmMindNodeModel]()
        for answerNodeId in childNodeIdList {
            let nodeId = answerNodeId.MindNodeChildId
            let answerNode = self.selectNodeByNodeId(nodeId: nodeId)
            localAnswerNodeArray.append(answerNode)
        }
        return localAnswerNodeArray
    }

    func calculateNextDateWhenCorrect(question:RealmMindNodeModel) -> LearningIntervalStruct{
        var learningIntervalStruct = LearningIntervalStruct(ifSuccessNextInterval: 0, nextLearningDate: 0)
        let nextInterval = question.ifSuccessInterval
        switch nextInterval {
            case Interval.first.rawValue:
                learningIntervalStruct.ifSuccessNextInterval = Interval.second.rawValue
                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.second.rawValue, to: Date())!.millisecondsSince1970
            case Interval.second.rawValue:
                learningIntervalStruct.ifSuccessNextInterval = Interval.third.rawValue
                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.third.rawValue, to: Date())!.millisecondsSince1970
            case Interval.third.rawValue:
                learningIntervalStruct.ifSuccessNextInterval = Interval.fourth.rawValue
                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.fourth.rawValue, to: Date())!.millisecondsSince1970
            case Interval.fourth.rawValue:
                learningIntervalStruct.ifSuccessNextInterval = Interval.fifth.rawValue
                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.fifth.rawValue, to: Date())!.millisecondsSince1970
            case Interval.fifth.rawValue:
                learningIntervalStruct.ifSuccessNextInterval = Interval.sixth.rawValue
                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.sixth.rawValue, to: Date())!.millisecondsSince1970
            case Interval.sixth.rawValue:
                learningIntervalStruct.ifSuccessNextInterval = Interval.sixth.rawValue
                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.sixth.rawValue, to: Date())!.millisecondsSince1970
            case 0:
                learningIntervalStruct.ifSuccessNextInterval = 1
                learningIntervalStruct.nextLearningDate = Calendar.current.date(byAdding: .day, value: Interval.first.rawValue, to: Date())!.millisecondsSince1970
            default:
                print("interval error")
        }
        return learningIntervalStruct
    }
    
}
