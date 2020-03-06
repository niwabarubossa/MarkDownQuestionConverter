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
    func didGetMapQuestion(question:[RealmMindNodeModel])
    func syncData(allNodeData:[RealmMindNodeModel])
}

class QuestionModel {
    weak var delegate: QuestionModelDelegate?
    var allNodeData = [RealmMindNodeModel]()
    
    func getMapQuestion(mapId:String){
        let realm = try! Realm()
        let results = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId)
        for node in results {
            self.allNodeData.append(node)
        }
        self.delegate?.didGetMapQuestion(question: allNodeData)
    }
    
    func getToDoQuestion(){
        let realm = try! Realm()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let todayEnd = Calendar.current.startOfDay(for: tomorrow!).millisecondsSince1970 - 1
        let results = realm.objects(RealmMindNodeModel.self).filter("nextDate BETWEEN {0, \(todayEnd)}")
        print("results.count")
        print("\(results.count) 件あります。")
        var questionArray = [RealmMindNodeModel]()
        for question in results {
            questionArray.append(question)
        }
        self.allNodeData = questionArray
        self.delegate?.didGetMapQuestion(question: questionArray)
    }
    
    func trailingSwipeAction(swipedAnswer:RealmMindNodeModel){
        //正解時
        let learningIntervalStruct = self.calculateNextDateWhenCorrect(question: swipedAnswer)
        self.updateMapQuestion(learningIntervalStruct: learningIntervalStruct, focusNode: swipedAnswer)
        let removeNodeIndex = self.convertNodeIdToIndex(node: swipedAnswer)
        //removeして反映
        self.allNodeData.remove(at: removeNodeIndex)
        self.syncData()
    }
    
    func convertNodeIdToIndex(node:RealmMindNodeModel)->Int{
        let index:Int = self.allNodeData.filter({$0.myNodeId == node.myNodeId}).first?.myNodeId ?? 0
        return index
    }
    
    private func syncData(){
        self.delegate?.syncData(allNodeData: allNodeData)
    }

    func leadingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        //不正解時
        let learningIntervalStruct = self.calculateNextDateWhenWrong()
        self.updateMapQuestion(learningIntervalStruct: learningIntervalStruct, focusNode: swipedAnswer)
        //removeせず　nextDate が今日になったことを反映
        self.syncData()
    }
    
    
    func searchNextQuestionNodeId(displayingQustion:RealmMindNodeModel) -> Int{
        //have childなnodeつまり、questionとなりうるnodeを表示する。 answer持たない奴はquestionになれないので、ここでスキップ
        let diplayingNodeId = displayingQustion.myNodeId
        var nextQuestionNodeId:Int = 0
        for nodeId in diplayingNodeId+1..<self.allNodeData.count {
            let node = selectNodeByNodeId(nodeId: nodeId)
            if (node.childNodeIdArray.count > 0){
                nextQuestionNodeId = nodeId
                return nextQuestionNodeId
            }
            if (nodeId == self.allNodeData.count - 1 ){
                print("もうクイズはありません。")
                return 0
            }
        }
        print("もうクイズないよ")
        return nextQuestionNodeId
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
    
    func calculateNextDateWhenWrong() -> LearningIntervalStruct{
        return LearningIntervalStruct(ifSuccessNextInterval: 1, nextLearningDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!.millisecondsSince1970)
    }

    
}
