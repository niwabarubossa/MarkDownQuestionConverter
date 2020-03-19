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

protocol QuestionModelViewProtocol: class {
    func reloadQuestionModelView()
}

protocol QuestionModelPresenterProtocol: class{
    func notifyToQuestionModelView() //notifyによって　model → presenter → viewをデータ同期
}

protocol QuestionModelProtocolNotify: class {
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
    func notifyToPresenter()
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
//答えのみ取得。答えに次の復習時間を記録しているので。　答えのparentNodeをクイズデータとして取得
        let results = realm.objects(RealmMindNodeModel.self).filter("nextDate BETWEEN {0, \(todayEnd)}").filter("isAnswer == %@",true).sorted(byKeyPath: "ifSuccessInterval", ascending: false).sorted(byKeyPath: "nextDate", ascending: true)
        print("\(results.count) 件あります。 これはanswerNode。これを元にquestion 取得します")
//FIX 大元の親は parent0 child0 だから、自分を取得しちゃうので排除しよう
        var questionArray = [RealmMindNodeModel]()
        var alreadyExist = [String]()
        for answerNode in results {
            //get parent node つまりquestionNOde
            let question:RealmMindNodeModel = self.getNodeFromRealm(mapId:answerNode.mapId,nodeId: answerNode.parentNodeId)
            //TODO oukyuushotitosite大元のnodeを省くif２重処理。
            if question.myNodeId != question.parentNodeId {
                if alreadyExist.contains(question.nodePrimaryKey) == false{
                    //TODO equatable 実装したからいける？
                    questionArray.append(question)
                    alreadyExist.append(question.nodePrimaryKey)
                }
            }
        }
        self.allNodeData = questionArray
        self.delegate?.didGetMapQuestion(question: questionArray)
    }
    
    private func alreadyExist(array: [RealmMindNodeModel],node:RealmMindNodeModel)->Bool{
        return false
    }
    
    func getNodeFromRealm(mapId:String,nodeId: Int) -> RealmMindNodeModel{
        let realm = try! Realm()
        let node:RealmMindNodeModel = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId).filter("myNodeId == %@", nodeId).first ?? RealmMindNodeModel()
        return node
    }
    
    
//    trailingSwipeAction  → leading
    func trailingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        //不正解時
        let learningIntervalStruct = self.calculateNextDateWhenWrong()
        self.updateMapQuestion(learningIntervalStruct: learningIntervalStruct, focusNode: swipedAnswer)
        //removeせず　nextDate が今日になったことを反映
        self.syncDataAndNotifyPresenter()
    }
    
    func convertNodeIdToIndex(node:RealmMindNodeModel)->Int{
        let index:Int = self.allNodeData.filter({$0.nodePrimaryKey == node.nodePrimaryKey}).first?.myNodeId ?? 0
        return index
    }
    
    func deleteNodeFromModel(deleteNode: RealmMindNodeModel){
        print("\(self.allNodeData.count)件数 削除前")
        if let removeIndex = self.allNodeData.firstIndex(of: deleteNode){
            self.allNodeData.remove(at: removeIndex)
        }
        print("\(self.allNodeData.count)件数 削除後")
        self.syncDataAndNotifyPresenter()
    }
    
    private func syncDataAndNotifyPresenter(){     
        self.delegate?.syncData(allNodeData: allNodeData)
        self.notifyToPresenter()
    }

    func leadingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        //正解時
        let learningIntervalStruct = self.calculateNextDateWhenCorrect(question: swipedAnswer)
        self.updateMapQuestion(learningIntervalStruct: learningIntervalStruct, focusNode: swipedAnswer)
        self.syncDataAndNotifyPresenter()
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
            focusNode?.setValue(Date().millisecondsSince1970,forKey: "lastAnswerdTime")
        }
        
    }
    
    func updateMapQuestionIsAnswer(updateNode:RealmMindNodeModel,isAnswer:Bool){
        let answerNode = self
            .searchByPrimaryKey(node: updateNode)
        var questionNode = RealmMindNodeModel()
        if let tempQuesiton = self.allNodeData.filter({ $0.mapId == updateNode.mapId && $0.myNodeId == updateNode.parentNodeId }).first {
            questionNode = tempQuesiton
        }
        do{
            let realm = try Realm()
            try! realm.write {
                answerNode?.setValue(isAnswer, forKey: "isAnswer")
            }
        }catch{
            print("\(error)")
        }
//書き換える、データの更新は子供（answer)。allNodeDataにはクイズが入っているので、それを削除
//FIXME 汎用的にする必要あり。
        if let questionNode = self.allNodeData.filter({ $0.mapId == updateNode.mapId && $0.myNodeId == questionNode.myNodeId  }).first {
            if let removeIndex = self.allNodeData.firstIndex(of: questionNode){
                self.allNodeData.remove(at: removeIndex)
            }
        }
        self.syncDataAndNotifyPresenter()
    }
    
    func searchByPrimaryKey(node:RealmMindNodeModel) -> RealmMindNodeModel?{
        let realm = try! Realm()
        let searchResult:RealmMindNodeModel? = realm.objects(RealmMindNodeModel.self).filter("nodePrimaryKey == %@", node.nodePrimaryKey).first
        return searchResult
    }
    
    func selectNodeByNodeId(nodeId:Int) -> RealmMindNodeModel{
        let selectedNode:RealmMindNodeModel = self.allNodeData.filter({ $0.myNodeId == nodeId }).first ?? RealmMindNodeModel()
        return selectedNode
    }
    
    func getAnswerNodeArray(displayingQuestion:RealmMindNodeModel) -> [RealmMindNodeModel]{
        var localAnswerNodeArray = [RealmMindNodeModel]()
        for answerNodeId in displayingQuestion.childNodeIdArray {
            let nodeId = answerNodeId.MindNodeChildId
            let answerNode = self.getNodeFromRealm(mapId: displayingQuestion.mapId, nodeId: nodeId)
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
    
    func getNodeByNodeIdAndMapId(question:RealmMindNodeModel,nodeId: Int) -> RealmMindNodeModel{
        let realm = try! Realm()
        if let searchResult = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", question.mapId).filter("myNodeId == %@",nodeId).first {
            return searchResult
        }
        
        return RealmMindNodeModel()
    }

}

extension QuestionModel:QuestionModelProtocolNotify{
    
    var notificationName: Notification.Name {
        return Notification.Name.questionModelUpdate
     }
    
    func notifyToPresenter() {
        NotificationCenter.default.post(name: notificationName, object:nil)
    }
    
    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
}
