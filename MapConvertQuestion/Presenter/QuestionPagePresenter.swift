//
//  QuestionPagePresenter.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

class QuestionPagePresenter:QuestionModelDelegate{
    //自分用のモデルの宣言
    let questionModel: QuestionModel
    var quizDataSource = [RealmMindNodeModel]()
    var displayingQustion:RealmMindNodeModel = RealmMindNodeModel()
    var answerNodeArray = [RealmMindNodeModel]()
    
    //オリジナルのクラス型にすること
    weak var view: QuestionPageViewController?

    init(view: QuestionPageViewController) {
        self.view = view
        self.questionModel = QuestionModel()
        questionModel.delegate = self
    }
    
    func dataSourceIndexCheck(index:Int) -> Bool{
        if index > self.quizDataSource.count { return false }
        return true
    }

    func getQuestionFromModel(mapId:String){
        questionModel.getMapQuestion(mapId:mapId)
    }
    
    func didGetMapQuestion(question: Results<RealmMindNodeModel>){
        for item in question {
            self.quizDataSource.append(item)
        }
        self.reloadQAPair(questionNodeId:0) //最初はタイトルからのクイズで
        self.notifyNodeToView()
        self.changeToQuestionMode()
    }
    
    func reloadQAPair(questionNodeId:Int){
        self.displayingQustion = selectNodeByNodeId(nodeId: questionNodeId)
        self.answerNodeArray = getAnswerNodeArray(childNodeIdList: self.displayingQustion.childNodeIdArray)
        self.notifyNodeToView()
        self.renderingView()
        self.changeToQuestionMode()
    }
    
    private func searchNextQuestionNodeId() -> Int{
        //have childなnodeつまり、questionとなりうるnodeを表示する。 answer持たない奴はquestionになれないので、ここでスキップ
        let diplayingNodeId = self.displayingQustion.myNodeId
        var nextQuestionNodeId:Int = 0
        for nodeId in diplayingNodeId+1..<self.quizDataSource.count {
            let node = selectNodeByNodeId(nodeId: nodeId)
            if (node.childNodeIdArray.count > 0){
                nextQuestionNodeId = nodeId
                return nextQuestionNodeId
            }
            if (nodeId == self.quizDataSource.count - 1 ){
                print("もうクイズはありません。")
                return 0
            }
        }
        print("もうクイズないよ")
        return nextQuestionNodeId
    }
    
    private func getAnswerNodeArray(childNodeIdList:List<MindNodeChildId>) -> [RealmMindNodeModel]{
        var localAnswerNodeArray = [RealmMindNodeModel]()
        for answerNodeId in childNodeIdList {
            let nodeId = answerNodeId.MindNodeChildId
            let answerNode = selectNodeByNodeId(nodeId: nodeId)
            localAnswerNodeArray.append(answerNode)
        }
        return localAnswerNodeArray
    }
    
    func notifyNodeToView(){
        self.view?.displayingNode = self.displayingQustion
        self.view?.answerMindNodeArray = self.answerNodeArray
    }
    
    private func renderingView(){
        self.view?.customView.questionDisplayLabel.text = self.displayingQustion.content
        self.view?.answerMindNodeArray = self.answerNodeArray
        self.view?.dataSource = self.answerNodeArray
        print("reload data")
        self.view?.questionAnswerTableView.reloadData()
    }
    
    func nextButtonTapped(){
        if (self.quizDataSource.count < 1) { return }
        let nextQuestionNodeId:Int = self.searchNextQuestionNodeId()
        self.reloadQAPair(questionNodeId: nextQuestionNodeId)
        self.changeToQuestionMode()
    }
        
    private func haveAnswerChild(node:RealmMindNodeModel) -> Bool{
        if (node.childNodeIdArray.count > 0){ return true }
        return false
    }
    
    private func selectNodeByNodeId(nodeId:Int) -> RealmMindNodeModel{
        let selectedNode:RealmMindNodeModel = self.quizDataSource.filter({ $0.myNodeId == nodeId }).first ?? RealmMindNodeModel()
        return selectedNode
    }
    
    func changeToSelectedAnswerQuiz(tappedNodeId:Int){
        let tappedNode = self.selectNodeByNodeId(nodeId: tappedNodeId)
        print("tappedNode")
        print("\(tappedNode)")
        let nextQuestionId = tappedNodeId
        self.reloadQAPair(questionNodeId: nextQuestionId)
    }
    
    private func changeToQuestionMode(){
        view?.customView.questionDisplayLabel.isHidden = false
        view?.questionAnswerTableView.isHidden = true
    }
    
    private func changeToAnswerMode(){
        view?.customView.questionDisplayLabel.isHidden = true
        view?.questionAnswerTableView.isHidden = false
    }
    
    func showAnswerButtonTapped(){
        self.changeToAnswerMode()
    }
    
    func correctAnswer(row:Int){
        let swipedAnswer = self.answerNodeArray[row]
        let learningIntervalStruct = calculateNextDateWhenCorrect(question: swipedAnswer)
        questionModel.updateMapQuestion(learningIntervalStruct:learningIntervalStruct,focusNode:swipedAnswer)
    }
    
    private func calculateNextDateWhenCorrect(question:RealmMindNodeModel) -> LearningIntervalStruct{
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
    
    func wrongAnswer(row:Int){
        let swipedAnswer = self.answerNodeArray[row]
        let learningIntervalStruct = calculateNextDateWhenWrong()
       questionModel.updateMapQuestion(learningIntervalStruct:learningIntervalStruct,focusNode:swipedAnswer)
    }
    
    private func calculateNextDateWhenWrong() -> LearningIntervalStruct{
        return LearningIntervalStruct(ifSuccessNextInterval: 1, nextLearningDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!.millisecondsSince1970)
    }
    
}
