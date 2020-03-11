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
    let userModel:UserDataModel
    //オリジナルのクラス型にすること
    weak var view:ToDoQuestionPageViewController?
    var quizDataSource = [RealmMindNodeModel]()
    var displayingQustion:RealmMindNodeModel = RealmMindNodeModel()
    var answerNodeArray = [RealmMindNodeModel]()
    var solvedAnswerId = [String]()
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
    
    //勝手に呼ばれる　from presenter
    func initializePage(){
        myModel.getToDoQuestion()
        userModel.getUserData()
    }
    
    func didGetMapQuestion(question: [RealmMindNodeModel]) {
        self.quizDataSource = question
        self.view?.userDataDisplay.bunboLabel.text = String(self.quizDataSource.count)
        self.view?.userDataDisplay.bunsiLabel.text = String(self.quizDataSource.count)
    }
    
    func syncUserData(user:User){
        self.user = user
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
        self.startQuestionTime = Date()
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
    
//    func trailingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
//データ更新する
    func leadingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
//leadingSwipeQuestion = 正解
               //データ更新する
        myModel.leadingSwipeQuestion(swipedAnswer: swipedAnswer)
        self.createQuestionLog(isCorrect:true,swipedAnswer: swipedAnswer)
         //データ更新は終了しているので、ここでクイズとして完全にノルマが終わっているか判定
        //button view settings edit
        let removeQuestionSwitch = self.removeSwipedAnswer()
        if removeQuestionSwitch == true {
            myModel.deleteNodeFromModel(deleteNode: self.displayingQustion)
        }
        userModel.updateUserData(swipedAnswer: swipedAnswer)
    }
    
    private func createQuestionLog(isCorrect:Bool,swipedAnswer:RealmMindNodeModel){
        do{
            let realm = try Realm()
            let thinkingTime = Double(Date().millisecondsSince1970 - self.startQuestionTime.millisecondsSince1970) / 1000
            
            let questionLog = QuestionLog(value: [
                "questionNodeId": self.displayingQustion.nodePrimaryKey,
                "thinkingTime": thinkingTime,
                "isCorrect": isCorrect,
                "mapId": swipedAnswer.mapId,
                //TODO インデント込みの文字数になっているので治すこと
                "charactersAmount": swipedAnswer.content.count
            ])
            try! realm.write {
                realm.add(questionLog)
            }
        }catch{
            print("\(error)")
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
    
    func trailingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        //不正解
        myModel.trailingSwipeQuestion(swipedAnswer: swipedAnswer)
        self.createQuestionLog(isCorrect:false,swipedAnswer: swipedAnswer)
    }
    
    func changeToSelectedAnswerQuiz(tappedNode:RealmMindNodeModel){
        let nextQuestion:RealmMindNodeModel = myModel.getNodeFromRealm(mapId: tappedNode.mapId, nodeId: tappedNode.myNodeId)
        self.reloadQAPair(nextQuestion: nextQuestion)
    }
    
    private func setQuestionArray(questionArray: [RealmMindNodeModel]){
        self.quizDataSource = questionArray
    }
}

extension ToDoQuestionPresenter:UserDataModelDelegate{
    
    func didGetUserData(user: User) {
        print("\(user)")
        self.user = user
    }

    @objc func userModelUpdateDone(notification: Notification){
        print("get observer ここでviewの更新をする")
        let answerTimesLabel = self.view?.userDataDisplay.answerTimesLabel
        let scoreLabel = self.view?.userDataDisplay.scoreLabel
        UIView.transition(with: answerTimesLabel!, // アニメーションさせるview
                        duration: 0.5, // アニメーションの秒数
                          options: [.transitionFlipFromBottom, .curveEaseIn],
                          animations: {
        },
                          completion:  { (finished: Bool) in
                            answerTimesLabel!.text = String(self.user.totalAnswerTimes) + "回"
        })
        UIView.transition(with: scoreLabel!, // アニメーションさせるview
                        duration: 0.5, // アニメーションの秒数
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
    }

}

extension ToDoQuestionPresenter:QuestionModelPresenterProtocol{
    @objc func notifyToQuestionModelView() {
        self.view?.reloadQuestionModelView()
        self.view?.userDataDisplay.bunsiLabel.text = String(self.quizDataSource.count)
        let bunboTextLabel = self.view?.userDataDisplay.bunboLabel.text
        if let bunboText = bunboTextLabel {
            let bunboFloat = NumberFormatter().number(from: bunboText)!.floatValue
            self.view?.userDataDisplay.progressView.setProgress( ( bunboFloat - Float(self.quizDataSource.count) ) / bunboFloat, animated: true)
        }
    }
}
