//
//  QuestionModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseFirestore

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

class QuestionModel:SubmitFirestoreDocProtocol {
    weak var delegate: QuestionModelDelegate?
    var allNodeData = [RealmMindNodeModel]()
    
    let mindNodeShared = RealmMindNodeAccessor.sharedInstance
    
    func getMapQuestion(mapId:String){
        let results = self.mindNodeShared.getNodeByMapIdGroup(mapId: mapId)
        for node in results {
            self.allNodeData.append(node)
        }
        self.delegate?.didGetMapQuestion(question: allNodeData)
    }
    
    func getToDoQuestion(){
        let results = mindNodeShared.getTodayAnswer()
//FIX 大元の親は parent0 child0 だから、自分を取得しちゃうので排除しよう
        var questionArray = [RealmMindNodeModel]()
        var alreadyExist = [String]()
        for answerNode in results {
            //get parent node つまりquestionNOde
            let question:RealmMindNodeModel = mindNodeShared.getNodeByMapIdAndNodeId(mapId:answerNode.mapId,nodeId: answerNode.parentNodeId)
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
    
    func trailingSwipeQuestion(swipedAnswer:RealmMindNodeModel){//不正解時
        let learningIntervalStruct = self.calculateNextDateWhenWrong()
        self.updateMapQuestion(learningIntervalStruct: learningIntervalStruct, focusNode: swipedAnswer)
        self.syncDataAndNotifyPresenter() //removeせず　nextDate が今日になったことを反映
    }
    
    func convertNodeIdToIndex(node:RealmMindNodeModel)->Int{
        let index:Int = self.allNodeData.filter({$0.nodePrimaryKey == node.nodePrimaryKey}).first?.myNodeId ?? 0
        return index
    }
    
    func deleteNodeFromModel(deleteNode: RealmMindNodeModel){
        if let removeIndex = self.allNodeData.firstIndex(of: deleteNode){
            self.allNodeData.remove(at: removeIndex)
        }
        self.syncDataAndNotifyPresenter()
    }
    
    private func syncDataAndNotifyPresenter(){     
        self.delegate?.syncData(allNodeData: allNodeData)
        self.notifyToPresenter()
    }

    func leadingSwipeQuestion(swipedAnswer:RealmMindNodeModel){ //正解時
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
        let focusNode = mindNodeShared.getNodeByMapIdAndNodeId(mapId: focusNode.mapId, nodeId: focusNode.myNodeId)
        let updateKeyValueArray:[String:Any] = [
            "ifSuccessInterval": learningIntervalStruct.ifSuccessNextInterval,
            "nextDate": learningIntervalStruct.nextLearningDate,
            "lastAnswerdTime":Date().millisecondsSince1970
            ]
        mindNodeShared.updateNode(updateKeyValueArray: updateKeyValueArray, updateNode: focusNode)
    }
    
    func updateMapQuestionIsAnswer(updateNode:RealmMindNodeModel,isAnswer:Bool){
        let answerNode = mindNodeShared.searchByPrimaryKey(node: updateNode)
        var questionNode = RealmMindNodeModel()
        if let tempQuesiton = self.allNodeData.filter({ $0.mapId == updateNode.mapId && $0.myNodeId == updateNode.parentNodeId }).first {
            questionNode = tempQuesiton
        }
        mindNodeShared.updateNode(updateKeyValueArray: ["isAnswer":isAnswer], updateNode: answerNode)
//書き換える、データの更新は子供（answer)。allNodeDataにはクイズが入っているので、それを削除
//FIXME 汎用的にする必要あり。
        if let questionNode = self.allNodeData.filter({ $0.mapId == updateNode.mapId && $0.myNodeId == questionNode.myNodeId  }).first {
            if let removeIndex = self.allNodeData.firstIndex(of: questionNode){
                self.allNodeData.remove(at: removeIndex)
            }
        }
        self.syncDataAndNotifyPresenter()
    }

    func selectNodeByNodeId(nodeId:Int) -> RealmMindNodeModel{
        let selectedNode:RealmMindNodeModel = self.allNodeData.filter({ $0.myNodeId == nodeId }).first ?? RealmMindNodeModel()
        return selectedNode
    }
    
    func getAnswerNodeArray(displayingQuestion:RealmMindNodeModel) -> [RealmMindNodeModel]{
        var localAnswerNodeArray = [RealmMindNodeModel]()
        for answerNodeId in displayingQuestion.childNodeIdArray {
            let nodeId = answerNodeId.MindNodeChildId
            let answerNode = mindNodeShared.getNodeByMapIdAndNodeId(mapId: displayingQuestion.mapId, nodeId: nodeId)
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
    
    func getMapTitle(question:RealmMindNodeModel) -> String {
        let indexQuestion = mindNodeShared.getNodeByNodeIdAndMapId(question: question,nodeId: 0)
        return indexQuestion.content == "" ? "no map title" : indexQuestion.content
    }
    
    func quizSubmitToFirestore(){
        let uuid = (UserDefaults.standard.object(forKey: "uuid"))!
        var answerDataArray = [RealmMindNodeModel]()
        let realm = try! Realm()
        let results = realm.objects(RealmMindNodeModel.self).filter("nextDate > 0")
        let maxIndex = min(results.count, 30)
        for _ in 0..<maxIndex {
            if let randomResult = results.randomElement() {
                answerDataArray.append(randomResult)
            }
        }

        let batch = Firestore.firestore().batch()
        for answer in answerDataArray {
            let question:RealmMindNodeModel = mindNodeShared.getNodeByMapIdAndNodeId(mapId:answer.mapId,nodeId: answer.parentNodeId)
            let mapTitle = self.getMapTitle(question: question)
            if mapTitle != "tutorial".localized {
                let submit_data = [
                    "mapTitle": mapTitle,
                    "question": question.content,
                    "answer": answer.content
                ] as [String:Any]
                let ref: DocumentReference = Firestore.firestore().collection("user").document("\(uuid)").collection("question").document()
                batch.setData(submit_data, forDocument: ref)
            }
        }
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
                return
            }
            print("Batch write succeeded.")
        }
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
