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
    
    let questionModel: QuestionModel
    var quizDataSource = [RealmMindNodeModel]()
    var displayingQustion:RealmMindNodeModel = RealmMindNodeModel()
    //viewから参照されている。 answerTableViewCellの数を決定
    var answerNodeArray = [RealmMindNodeModel]()
    
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
    
    func didGetMapQuestion(question: [RealmMindNodeModel]){
        self.quizDataSource = question
        self.reloadQAPair(questionNodeId:0) //最初はタイトルからのクイズで
        self.changeToQuestionMode()
    }
    
    func reloadQAPair(questionNodeId:Int){
        self.displayingQustion = questionModel.selectNodeByNodeId(nodeId: questionNodeId)
        self.answerNodeArray = questionModel.getAnswerNodeArray(displayingQuestion: self.displayingQustion)
        self.renderingView()
        self.changeToQuestionMode()
    }
    
    private func searchNextQuestionNodeId() -> Int{
        //have childなnodeつまり、questionとなりうるnodeを表示する。 answer持たない奴はquestionになれないので、ここでスキップ
        let diplayingNodeId = self.displayingQustion.myNodeId
        var nextQuestionNodeId:Int = 0
        for nodeId in diplayingNodeId+1..<self.quizDataSource.count {
            let node = questionModel.selectNodeByNodeId(nodeId: nodeId)
            if (node.childNodeIdArray.count > 0){
                nextQuestionNodeId = nodeId
                return nextQuestionNodeId
            }
            //クイズない状態↓
            if (nodeId == self.quizDataSource.count - 1 ){ return 0 }
        }
        //クイズない状態↓
        return nextQuestionNodeId
    }
    
    private func renderingView(){
        self.view?.customView.questionDisplayLabel.text = self.displayingQustion.content.replacingOccurrences(of: "\t", with: "")
        self.view?.questionAnswerTableView.reloadData()
    }
    
    func nextButtonTapped(){
        if (self.quizDataSource.count < 1) { return }
        let nextQuestionNodeId:Int = self.searchNextQuestionNodeId()
        self.reloadQAPair(questionNodeId: nextQuestionNodeId)
        self.changeToQuestionMode()
    }
    
    func changeToSelectedAnswerQuiz(tappedNodeId:Int){
        let nextQuestionId = tappedNodeId
        self.reloadQAPair(questionNodeId: nextQuestionId)
    }
    
    private func changeToQuestionMode(){
        view?.customView.isHidden = false
        view?.questionAnswerTableView.isHidden = true
    }
    
    private func changeToAnswerMode(){
        view?.customView.isHidden = true
        view?.questionAnswerTableView.isHidden = false
    }
    
    func showAnswerButtonTapped(){
        self.changeToAnswerMode()
    }
    
    func abandonQuestionButtonTapped(){
        for answerNode in self.answerNodeArray {
            questionModel.updateMapQuestionIsAnswer(updateNode: answerNode, isAnswer: false)
        }
        self.syncData(allNodeData: self.answerNodeArray)
    }
    
    func correctAnswer(row:Int){
        let swipedAnswer = self.answerNodeArray[row]
    }
    
    func wrongAnswer(row:Int){
        let swipedAnswer = self.answerNodeArray[row]
    }
    
    func syncData(allNodeData: [RealmMindNodeModel]) {
        //TODO protocol調整用。　２つにまたがるprotocol
        print("\(allNodeData)")
    }

}
