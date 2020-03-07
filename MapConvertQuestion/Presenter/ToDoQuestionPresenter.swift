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
            self.view?.noQuestionLabel.isHidden = false
            self.changeToCompleteMode()
            print("self.quizDataSource.count < 1")
            print("no question ! todays todo question is complete!")
            return
        }
        //reloadする　解いたやつremove
        let nextQuestion:RealmMindNodeModel = self.quizDataSource.shuffled()[0]
        
        self.reloadQAPair(nextQuestion: nextQuestion)
        self.changeToQuestionMode()
    }
        
    func didGetToDoQuestion(questionArray: [RealmMindNodeModel]) {
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
    
    func changeToSelectedAnswerQuiz(tappedNode:RealmMindNodeModel){
        let nextQuestion:RealmMindNodeModel = myModel.getNodeFromRealm(mapId: tappedNode.mapId, nodeId: tappedNode.myNodeId)
        self.reloadQAPair(nextQuestion: nextQuestion)
    }
    
    private func setQuestionArray(questionArray: [RealmMindNodeModel]){
        self.quizDataSource = questionArray
    }
}

extension ToDoQuestionPresenter {
    func reloadQAPair(nextQuestion:RealmMindNodeModel){
    //focusNodeはタップされたもの、
    //nextBUttonTapped 時はランダムな未解決displayingQが入っている
        self.displayingQustion = nextQuestion
        self.answerNodeArray.removeAll()
        for childNodeId in nextQuestion.childNodeIdArray {
            let answerNode = myModel.getNodeFromRealm(mapId: nextQuestion.mapId, nodeId: childNodeId.MindNodeChildId)
            self.answerNodeArray.append(answerNode)
        }
        self.notifyNodeToView()
        self.renderingView()
        self.changeToQuestionMode()
    }
    
    func notifyNodeToView(){
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
    
    private func changeToCompleteMode(){
        view?.customView.isHidden = true
        view?.answerTableView.isHidden = true
    }

}
