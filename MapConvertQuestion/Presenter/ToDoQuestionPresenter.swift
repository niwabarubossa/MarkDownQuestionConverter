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

class ToDoQuestionPresenter:ToDoQuestionModelDelegate,QuestionModelDelegate,RealmCreateProtocol{
    let myModel: QuestionModel
    let userModel:UserDataModel
    weak var view:ToDoQuestionPageViewController?
    
    var quizDataSource = [RealmMindNodeModel]()
    var displayingQustion:RealmMindNodeModel = RealmMindNodeModel()
    var answerNodeArray = [RealmMindNodeModel]()
    var user = User()
    var startQuestionTime:Date = Date()

    init(view: ToDoQuestionPageViewController) {
        self.view = view
        self.myModel = QuestionModel()
        self.userModel = UserDataModel()
        userModel.delegate = self
        myModel.delegate = self
        myModel.addObserver(self, selector: #selector(self.notifyToQuestionModelView))
        userModel.addObserver(self, selector:#selector(self.userModelUpdateDone))
    }
    
    //初期化時に呼ばれる　from presenter
    func initializePage(){
        myModel.getToDoQuestion()
        userModel.getUserData()
        self.view?.customView.questionLabel.isHidden = false
        self.view?.answerTableView.isHidden = true
    }
    
    func didGetMapQuestion(question: [RealmMindNodeModel]) {
        //初期化処理
        self.quizDataSource = question
        question.count > 0 ? self.displayingQustion = self.quizDataSource.shuffled()[0] : print("no question")
        let firstQuestion = self.displayingQustion
        self.renderingView()
        self.reloadQAPair(nextQuestion: firstQuestion)
        self.view?.userDataDisplay.bunboLabel.text = String(self.quizDataSource.count)
        self.view?.userDataDisplay.bunsiLabel.text = String(self.quizDataSource.count)
        self.userDisplayReload()
        self.userModelUpdateDone()
    }
    
    func syncUserData(user:User){
        self.user = user
    }
    
    //model とpresenter同期
    func syncData(allNodeData: [RealmMindNodeModel]) {
        self.quizDataSource = allNodeData
    }
    
    func answerButtonTapped(){
        self.changeToAnswerMode()
        self.setAnswerNodeArray(question: self.displayingQustion)
        self.answerButtonDisabled()
    }
    
    private func answerButtonDisabled(){
        self.view?.buttonStackView.answerButton.isEnabled = false
        self.view?.buttonStackView.answerButton.alpha = 0.5
    }
    func answerButtonEnabled(){
        self.view?.buttonStackView.answerButton.isEnabled = true
        self.view?.buttonStackView.answerButton.alpha = 1
    }
    
    func nextQuestionButtonTapped(){
        self.startQuestionTime = Date()
        if (self.quizDataSource.count < 1) {
            self.view?.noQuestionLabel.isHidden = false
            self.changeToCompleteMode()
            print("no question ! todays todo question is complete!")
            return
        }
        if self.quizDataSource.count == 1 {
            self.view?.buttonStackView.nextQuestionButton.isEnabled = false
            self.view?.buttonStackView.nextQuestionButton.alpha = 0.5
        }
        let nextQuestion:RealmMindNodeModel = self.shuffleQuestion()
        self.reloadQAPair(nextQuestion: nextQuestion)
        self.changeToQuestionMode()
        self.answerButtonEnabled()
    }
    
    private func shuffleQuestion() -> RealmMindNodeModel{
        //同じ問題が連続で出題されるのを避ける
        var nextQuestion = self.quizDataSource.shuffled()[0]
        if self.quizDataSource.count == 1 { return self.quizDataSource[0] }
        while (nextQuestion.nodePrimaryKey == self.displayingQustion.nodePrimaryKey )  {
            nextQuestion = self.quizDataSource.shuffled()[0]
        }
        return nextQuestion
    }
    
    
    func abandonQuestionButtonTapped(){
        for answerNode in self.answerNodeArray {
            myModel.updateMapQuestionIsAnswer(updateNode: answerNode, isAnswer: false)
        }
        let removeQuestion = self.displayingQustion
        if let removeIndex =  self.quizDataSource.firstIndex(of: removeQuestion) {
            self.quizDataSource.remove(at: removeIndex)
        }
        self.notifyToQuestionModelView()
        self.nextQuestionButtonTapped()
    }
        
    //removeするやつ
    func didGetToDoQuestion(questionArray: [RealmMindNodeModel]) {
        self.setQuestionArray(questionArray: questionArray)
        if questionArray.count == 0 {
            self.changeToCompleteMode()
        }
    }
    
    func leadingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
//leadingSwipeQuestion = 正解
//データ更新する
        myModel.leadingSwipeQuestion(swipedAnswer: swipedAnswer)
        self.createQuestionLog(isCorrect:true,swipedAnswer: swipedAnswer)
         //データ更新は終了してる。クイズノルマが全て終わっているか判定
        let removeQuestionSwitch = self.removeSwipedAnswerJudge()
        if removeQuestionSwitch == true {
            myModel.deleteNodeFromModel(deleteNode: self.displayingQustion)
            self.nextQuestionButtonTapped()
        }
        userModel.updateUserData(swipedAnswer: swipedAnswer)
    }
    
    private func createQuestionLog(isCorrect:Bool,swipedAnswer:RealmMindNodeModel){
            let thinkingTime = Double(Date().millisecondsSince1970 - self.startQuestionTime.millisecondsSince1970) / 1000
            let questionLog = QuestionLog(value: [
                "questionNodeId": self.displayingQustion.nodePrimaryKey,
                "thinkingTime": thinkingTime,
                "isCorrect": isCorrect,
                "mapId": swipedAnswer.mapId,
                //TODO インデント込みの文字数になっているので治すこと
                "charactersAmount": swipedAnswer.content.replacingOccurrences(of:"\t", with:"").count,
                "latitude": self.view?.latitudeNow ?? "",
                "longitude": self.view?.longitudeNow ?? ""
            ])
            self.createRealm(data: questionLog)
    }
    
    private func removeSwipedAnswerJudge()->Bool{
        for answerNode in self.answerNodeArray {
            if isTodayToDoQuestion(question: answerNode) == true {
                //１つでも今日のやつが残っているならまだ消さない
                return false
            }
        }
        //全てのanswerが,0~todayの範囲を超えていたらOK,removeする。
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
    
    func trailingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        //不正解
        myModel.trailingSwipeQuestion(swipedAnswer: swipedAnswer)
        self.createQuestionLog(isCorrect:false,swipedAnswer: swipedAnswer)
    }
    
    func changeToSelectedAnswerQuiz(tappedNode:RealmMindNodeModel){
        self.answerButtonEnabled()
        let nextQuestion:RealmMindNodeModel = myModel.getNodeFromRealm(mapId: tappedNode.mapId, nodeId: tappedNode.myNodeId)
        self.reloadQAPair(nextQuestion: nextQuestion)
    }
    
    private func setQuestionArray(questionArray: [RealmMindNodeModel]){
        self.quizDataSource = questionArray
    }
}

extension ToDoQuestionPresenter:UserDataModelDelegate{
    
    func didGetUserData(user: User) {
        self.user = user
    }

//    @objc func userModelUpdateDone(notification: Notification){
    @objc func userModelUpdateDone(){
        print("userに関する情報、今回はuserDisplay情報が更新されました")
        let answerTimesLabel = self.view?.userDataDisplay.answerTimesLabel
        let scoreLabel = self.view?.userDataDisplay.scoreLabel
        UIView.transition(with: answerTimesLabel!,
                        duration: 0.5,
                          options: [.transitionFlipFromBottom, .curveEaseIn],
                          animations: {
        },
                          completion:  { (finished: Bool) in
                            answerTimesLabel!.text = String(self.user.totalAnswerTimes) + "回"
        })
        UIView.transition(with: scoreLabel!,
                        duration: 0.5,
                          options: [.transitionFlipFromBottom, .curveEaseIn],
                          animations: {
        },
                          completion:  { (finished: Bool) in
                            scoreLabel!.text = String(self.user.totalCharactersAmount)
        })
    }
}

extension ToDoQuestionPresenter {
    func reloadQAPair(nextQuestion:RealmMindNodeModel){
        self.resetData()
        self.displayingQustion = nextQuestion
//        self.setAnswerNodeArray(question:nextQuestion)
        self.renderingView()
        self.quizDataSource.count > 0 ? self.changeToQuestionMode() : self.changeToCompleteMode()
        self.buttonEnabledControl()
    }
    
    private func resetData(){
        self.answerNodeArray.removeAll()
    }
    
    private func setAnswerNodeArray(question:RealmMindNodeModel){
        for childNodeId in question.childNodeIdArray {
            let answerNode = myModel.getNodeFromRealm(mapId: question.mapId, nodeId: childNodeId.MindNodeChildId)
            self.answerNodeArray.append(answerNode)
        }
        self.view?.answerTableView.reloadData()
    }
    
    //TODO protocolに準拠させよう viewRenderingなprotocol
    private func renderingView(){
        self.view?.customView.questionLabel.text = self.displayingQustion.content.replacingOccurrences(of:"\t", with:"")
//        self.view?.answerTableView.reloadData()
        
    }
    
    private func buttonEnabledControl(){
        if self.quizDataSource.count == 0{
            self.view?.buttonStackView.isHidden = true
            self.view?.buttonStackView.answerButton.isEnabled = false
            self.view?.buttonStackView.answerButton.alpha = 0.5
            //TODO 多くのこと一度にやりすぎているので分割しなきゃいけない
            print("complete!")
            self.changeToCompleteMode()
        }
    }
    
    func changeToQuestionMode(){
        UIView.transition(with: self.view!.customView, duration: 0.2, options: [.transitionFlipFromLeft], animations: {
            self.view!.customView.isHidden = true
            self.view!.answerTableView.isHidden = false
        }, completion: { (finished: Bool) in
            self.view!.customView.isHidden = false
            self.view!.answerTableView.isHidden = true
        })
    }
    
    private func changeToAnswerMode(){
        UIView.transition(with: self.view!.customView, duration: 0.3, options: [.transitionCurlUp], animations: {
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
        view?.buttonStackView.isHidden = true
        view?.noQuestionLabel.isHidden = false
    }

}

//viewの更新関連
extension ToDoQuestionPresenter:QuestionModelPresenterProtocol{
    @objc func notifyToQuestionModelView() {
        print("notify model change update")
        self.buttonEnabledControl()
        //状態確認
        self.view?.reloadQuestionModelView()
        //FIX ここで呼び出すの適切じゃないと思う
        self.userDisplayReload()
    }
    
    private func userDisplayReload(){
        let bunboTextLabel = self.view?.userDataDisplay.bunboLabel.text
        if let bunboText = bunboTextLabel {
            let bunboFloat = NumberFormatter().number(from: bunboText)!.floatValue
            let bunboInt = NumberFormatter().number(from: bunboText)!.intValue
            self.view?.userDataDisplay.bunsiLabel.text = String( bunboInt - self.quizDataSource.count)
            self.view?.userDataDisplay.progressView.setProgress( ( bunboFloat - Float(self.quizDataSource.count) ) / bunboFloat, animated: true)
        }
    }

}
