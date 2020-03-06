//
//  ToDoQuestionPresenter.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import Foundation
import UIKit

class ToDoQuestionPresenter:ToDoQuestionModelDelegate,QuestionModelDelegate{
    //自分用のモデルの宣言
    let myModel: QuestionModel
    //オリジナルのクラス型にすること
    weak var view:ToDoQuestionPageViewController?
    var quizDataSource = [RealmMindNodeModel]()
    var displayingQustion:RealmMindNodeModel = RealmMindNodeModel()
    var answerNodeArray = [RealmMindNodeModel]()

    init(view: ToDoQuestionPageViewController) {
        self.view = view
        self.myModel = QuestionModel()
        myModel.delegate = self
    }
    
    //勝手に呼ばれる　from presenter
    func initializePage(){
        myModel.getToDoQuestion()
    }
    
    func didGetMapQuestion(question: [RealmMindNodeModel]) {
        self.quizDataSource = question
    }
    
    func syncData(allNodeData: [RealmMindNodeModel]) {
        self.quizDataSource = allNodeData
    }
    // Presenter → Model 操作する側
    func toModelFromPresenter() {
//        myModel.testfunc()
    }

    //Presenter → View の操作  操作する側
    func toViewFromPresenter() {
        view?.testfunc()
    }
    
    func answerButtonTapped(){
        print("answerButtonTapped in presenter")
        self.changeToAnswerMode()
    }
    
    func nextQuestionButtonTapped(){
        print("nextQuestionButtonTapped in presenter")
        //select next question
        if (self.quizDataSource.count < 1) {
            print("self.quizDataSource.count < 1")
            print("no question ! todays todo question is complete!")
            return
        }
//        let nextQuestionNodeId:Int = myModel.searchNextQuestionNodeId(displayingQustion: self.displayingQustion)
        //reloadする　解いたやつremove
        let nextQuestionNodeId:Int = Int.random(in: 0..<self.quizDataSource.count)
        self.reloadQAPair(questionNodeId: nextQuestionNodeId)
        self.changeToQuestionMode()
    }
        
    func didGetToDoQuestion(questionArray: [RealmMindNodeModel]) {
        print("questionArray")
        print("\(questionArray)")
        self.setQuestionArray(questionArray: questionArray)
    }
    
    func trailingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        //データ更新する
         myModel.trailingSwipeAction(swipedAnswer: swipedAnswer)
    }
    
    func leadingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        //データ更新する
         myModel.leadingSwipeQuestion(swipedAnswer: swipedAnswer)
    }
    
    func changeToSelectedAnswerQuiz(tappedNodeId:Int){
        let nextQuestionId = tappedNodeId
        self.reloadQAPair(questionNodeId: nextQuestionId)
    }
    
    private func setQuestionArray(questionArray: [RealmMindNodeModel]){
        self.quizDataSource = questionArray
    }
}

extension ToDoQuestionPresenter {
    func reloadQAPair(questionNodeId:Int){
        self.displayingQustion = myModel.selectNodeByNodeId(nodeId: questionNodeId)
        self.answerNodeArray = myModel.getAnswerNodeArray(displayingQuestion: self.displayingQustion)
        print("self.answerNodeArray")
        print("\(self.answerNodeArray)")
        
        self.notifyNodeToView()
        self.renderingView()
        self.changeToQuestionMode()
    }
    
    func notifyNodeToView(){
        print("notifyNodeToView")
        self.view?.displayingNode = self.displayingQustion
        self.view?.answerNodeArrayDataSource = self.answerNodeArray
    }
    
    private func renderingView(){
        self.view?.customView.questionLabel.text = self.displayingQustion.content
        self.view?.answerNodeArrayDataSource = self.answerNodeArray
        self.view?.answerNodeArrayDataSource = self.answerNodeArray
        self.view?.answerTableView.reloadData()
    }
    
    private func changeToQuestionMode(){
        view?.customView.isHidden = false
        view?.answerTableView.isHidden = true
    }
    
    private func changeToAnswerMode(){
//        view?.customView.isHidden = true
        view?.answerTableView.isHidden = false
    }

}
