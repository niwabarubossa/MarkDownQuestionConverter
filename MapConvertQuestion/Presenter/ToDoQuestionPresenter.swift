//
//  ToDoQuestionPresenter.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

class ToDoQuestionPresenter:ToDoQuestionModelDelegate,QuestionModelDelegate{
    //自分用のモデルの宣言
    let myModel: QuestionModel
    //オリジナルのクラス型にすること
    weak var view:ToDoQuestionPageViewController?
    var quizDataSource = [RealmMindNodeModel]()
    var displayingQustion:RealmMindNodeModel = RealmMindNodeModel()
    var answerNodeArray = [RealmMindNodeModel]()
    var solvedAnswerId = [String]()

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
    
    //model とpresenter同期
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
    
    func abandonQuestionButtonTapped(){
        for answerNode in self.answerNodeArray {
            myModel.updateMapQuestionIsAnswer(updateNode: answerNode, isAnswer: false)
        }
    }
        
    func didGetToDoQuestion(questionArray: [RealmMindNodeModel]) {
        self.setQuestionArray(questionArray: questionArray)
    }
    
    func trailingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
//データ更新する
        myModel.trailingSwipeAction(swipedAnswer: swipedAnswer)
 //データ更新は終了しているので、ここでクイズとして完全にノルマが終わっているか判定
//button view settings edit
        let removeQuestionSwitch = self.removeSwipedAnswer()
        if removeQuestionSwitch == true {
            myModel.deleteNodeFromModel(deleteNode: self.displayingQustion)
        }
    }
    
    private func removeSwipedAnswer()->Bool{
        //不完全　クイズ途中でnext行かれた時にめんどくさい。
        // 今日１回解いたやつ　今日まだ解いてないやつ　の状態で次に行った場合、また遭遇した時に今日２回解いたやつ　今日１回解いたやつ　状態にならないとクイズが消えない
        for answerNode in self.answerNodeArray {
            if isTodayToDoQuestion(question: answerNode) == true {
//                １つでも今日のやつが残っているならまだ消さない
                return false
            }
        }
        //全てのanswerが,0~todayの範囲を超えていたらOKとする。つまりremove
        return true
    }
    
    private func isTodayToDoQuestion(question:RealmMindNodeModel) ->Bool{
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let todayEnd = Calendar.current.startOfDay(for: tomorrow!).millisecondsSince1970 - 1
        if question.nextDate >= 0 && todayEnd >= question.nextDate {
            return true
        }
        return false
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
        self.resetData()
        self.setAnswerNodeArray(question:nextQuestion)
        self.notifyNodeToView()
        self.renderingView()
        self.changeToQuestionMode()
    }
    
    private func resetData(){
        self.answerNodeArray.removeAll()
        self.solvedAnswerId.removeAll()
    }
    
    private func setAnswerNodeArray(question:RealmMindNodeModel){
        for childNodeId in question.childNodeIdArray {
            let answerNode = myModel.getNodeFromRealm(mapId: question.mapId, nodeId: childNodeId.MindNodeChildId)
            self.answerNodeArray.append(answerNode)
        }
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
        UIView.transition(with: self.view!.customView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
            self.view!.customView.isHidden = true
            self.view!.answerTableView.isHidden = false
        }, completion: { (finished: Bool) in
            self.view!.customView.isHidden = false
            self.view!.answerTableView.isHidden = true
        })
    }
    
    private func changeToAnswerMode(){
        UIView.transition(with: self.view!.customView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
            self.view!.customView.isHidden = false
            self.view!.answerTableView.isHidden = true
        }, completion: { (finished: Bool) in
            self.view!.customView.isHidden = true
            self.view!.answerTableView.isHidden = false
        })
    }
    
    private func changeToCompleteMode(){
        view?.customView.isHidden = true
        view?.answerTableView.isHidden = true
    }

}
