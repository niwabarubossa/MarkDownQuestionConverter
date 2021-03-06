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

class ToDoQuestionPresenter:QuestionModelDelegate,RealmCreateProtocol,RealmNodeJudgeProtocol{
    let myModel: QuestionModel
    let userModel:UserDataModel
    let questionLogModel: QuestionLogModel
    weak var view:ToDoQuestionPageViewController?
    
    var quizDataSource = [RealmMindNodeModel]()
    var displayingQustion:RealmMindNodeModel = RealmMindNodeModel()
    var answerNodeArray = [RealmMindNodeModel]()
    var experience:Float = Float.random(in: 0.2..<1)
//    var user = User()
    var user:User{
        userModel.user
    }
    var startQuestionTime:Date = Date()
    var mapTitle:String = ""
    
    var focusAnswerIndex:Int = 0

    var expDelta:Int = 0 //代入される

    init(view: ToDoQuestionPageViewController) {
        self.view = view
        self.myModel = QuestionModel()
        self.userModel = UserDataModel()
        self.questionLogModel = QuestionLogModel()
        userModel.delegate = self
        myModel.delegate = self
        myModel.addObserver(self, selector: #selector(self.notifyToQuestionModelView))
        userModel.addObserver(self, selector:#selector(self.userModelUpdateDone))
    }
    
    func initializePage(){ //初期化時に呼ばれる　from presenter
        myModel.getToDoQuestion()
        // get user
        self.view?.customView.questionLabel.isHidden = false
        self.view?.answerTableView.isHidden = true
        self.quizSubmitToFirestore()
    }
    
    func didGetMapQuestion(question: [RealmMindNodeModel]) { //初期化処理 model → presenter
        self.quizDataSource = question
        question.count > 0 ? self.displayingQustion = self.quizDataSource[0] : print("no question")
        let firstQuestion = self.displayingQustion
        self.renderingView()
        self.reloadQAPair(nextQuestion: firstQuestion)
        self.view?.userDataDisplay.bunboLabel.text = String(self.quizDataSource.count)
        self.view?.userDataDisplay.bunsiLabel.text = String(self.quizDataSource.count)
        self.userDisplayReload()
        self.userModelUpdateDone()
    }
        
    func answerButtonTapped(){
        self.changeToAnswerMode()
        self.setAnswerNodeArray(question: self.displayingQustion)
        self.answerButtonDisabled()
        
        self.focusAnswerIndex = self.getFirstFocusAnswerIndex()
        self.view?.answerTableView.reloadData()
        self.view?.answerTableView.selectRow(at: [0,self.focusAnswerIndex], animated: false, scrollPosition: .top)
    }
    
    private func getFirstFocusAnswerIndex() -> Int{
        for i in 0..<self.answerNodeArray.count{
            if self.betweenTodayRange(time: self.answerNodeArray[i].nextDate) {
                self.focusAnswerIndex = i
                return i
            }
        }
        return 0
    }
    
    private func answerButtonDisabled(){
        self.view?.buttonStackView.answerButton.isEnabled = false
        self.view?.buttonStackView.answerButton.alpha = 0.5
    }
    
    private func answerButtonEnabled(){
        self.view?.buttonStackView.answerButton.isEnabled = true
        self.view?.buttonStackView.answerButton.alpha = 1
    }
    
    func nextQuestionButtonTapped(){
        self.startQuestionTime = Date()
        if (self.quizDataSource.count < 1) {
            self.view?.noQuestionLabel.isHidden = false
            self.changeToCompleteMode()
            return
        }
        let nextQuestion:RealmMindNodeModel = self.getNextQuestion()
        self.reloadQAPair(nextQuestion: nextQuestion)
        self.changeToQuestionMode()
        self.answerButtonEnabled()
    }
    
    private func getNextQuestion() -> RealmMindNodeModel{
        if self.quizDataSource.count == 1 { return self.quizDataSource[0] }
        //同じ問題が連続で出題されるのを避ける
        var nextQuestion = self.quizDataSource[0]
        if nextQuestion.nodePrimaryKey == self.displayingQustion.nodePrimaryKey {
            if let randomQuiz = self.quizDataSource.randomElement() {
                self.swapQuizDataSource(node1: self.displayingQustion, node2: randomQuiz)
            }
            nextQuestion = self.quizDataSource[0]
        }
        return nextQuestion
    }
    
    private func swapQuizDataSource(node1:RealmMindNodeModel,node2:RealmMindNodeModel){
        let displayingQuestionIndex = quizDataSource.firstIndex(of: node1) ?? 0
        let randomQuestionIndex = quizDataSource.firstIndex(of: node2) ?? 0
        let temp = self.quizDataSource[randomQuestionIndex]
        self.quizDataSource[randomQuestionIndex] = self.quizDataSource[displayingQuestionIndex]
        self.quizDataSource[displayingQuestionIndex] = temp
    }
    
    func abandonQuestionButtonTapped(){
        self.setAnswerNodeArray(question: self.displayingQustion)
        for answerNode in self.answerNodeArray {
            myModel.updateMapQuestionIsAnswer(updateNode: answerNode, isAnswer: false)
        }
        let removeQuestion = self.displayingQustion
        if let removeIndex =  self.quizDataSource.firstIndex(of: removeQuestion) {
            self.quizDataSource.remove(at: removeIndex)
        }
        self.userModel.userShared.updateUserData(updateKeyValueArray: ["todayQuota": self.user.todayQuota - 1], updateUser: self.user)
        self.notifyToQuestionModelView()
        self.nextQuestionButtonTapped()
    }
    
    func leadingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        //正解時のアクション //データ更新
        let nextIndex = self.optimizeIndex(answerNode:swipedAnswer)
        self.view?.answerTableView.reloadData()
        self.view?.answerTableView.selectRow(at: [0,nextIndex], animated: false, scrollPosition: .top)
        

        
        myModel.leadingSwipeQuestion(swipedAnswer: swipedAnswer)
        self.createQuestionLog(isCorrect:true,swipedAnswer: swipedAnswer)
         //データ更新は終了してる。クイズノルマが全て終わっているか判定
        if self.removeSwipedAnswerJudge() == true { myModel.deleteNodeFromModel(deleteNode: self.displayingQustion) }
        if self.goNextQuestionJudge() == true { self.nextQuestionButtonTapped() }
        userModel.updateUserData(swipedAnswer: swipedAnswer)
        
        expDelta += swipedAnswer.content.replacingOccurrences(of:"\t", with:"").count
        
        self.getExperience()
        
    }
    
    private func optimizeIndex(answerNode:RealmMindNodeModel) -> Int{
        if let index = self.answerNodeArray.firstIndex(of: answerNode){
            for i in (index + 1)..<self.answerNodeArray.count{
                if self.betweenTodayRange(time: self.answerNodeArray[i].nextDate) {
                    self.focusAnswerIndex = i
                    return i
                }
            }
        }
        self.focusAnswerIndex = 0
        return 0
    }
    
    private func getExperience(){
//        self.experience = self.experience + self.calcLevelDelta()
//        self.experience = self.experience.truncatingRemainder(dividingBy: 1)
        
        let updatedLevel = self.getLevel(exp: Double(self.user.totalCharactersAmount))
        if self.user.level != updatedLevel {
            print("updatedLevel")
            print("\(updatedLevel)")
            userModel.updateUserLevel(level:Int64(updatedLevel))
        }
    }
    
    private func calcLevelDelta() -> Float{
        let randomDelta:Float = (Float.random(in: 0...1)) / 8
        let perExperience:Float = 1 / 8
        return randomDelta + perExperience
    }
    
    func getLevel(exp:Double) -> Int{
        var temp:Double = (exp + 300.0) / 330.0
        var level:Int = 0
        while temp >= 1.0 {
            temp = temp / 1.10
            level += 1
        }
      return level
    }

    
    private func goNextQuestionJudge()->Bool{
        for answerNode in self.answerNodeArray {
            if answerNode.lastAnswerdTime <= self.startQuestionTime.millisecondsSince1970 {
                if self.betweenTodayRange(time: answerNode.nextDate) { return false }
            }
        }
        return true
    }
    
    private func removeSwipedAnswerJudge()->Bool{
        for answerNode in self.answerNodeArray {
            //１つでも今日のやつが残っているならまだ消さない
            if isTodayToDoQuestion(question: answerNode) == true { return false }
        }
        //全てのanswerが,0~todayの範囲を超えていたらOK,removeする。
        return true
    }
    
    private func createQuestionLog(isCorrect:Bool,swipedAnswer:RealmMindNodeModel){
            let thinkingTime = Double(Date().millisecondsSince1970 - self.startQuestionTime.millisecondsSince1970) / 1000
            let questionLog = QuestionLog(value: [
                "questionNodeId": self.displayingQustion.nodePrimaryKey,
                "thinkingTime": thinkingTime,
                "isCorrect": isCorrect,
                "mapId": swipedAnswer.mapId,
                "charactersAmount": swipedAnswer.content.replacingOccurrences(of:"\t", with:"").count,
                "latitude": self.view?.latitudeNow ?? "",
                "longitude": self.view?.longitudeNow ?? ""
            ])
            self.createRealm(data: questionLog)
    }
        
    private func isTodayToDoQuestion(question:RealmMindNodeModel) ->Bool{
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let todayEnd = Calendar.current.startOfDay(for: tomorrow!).millisecondsSince1970 - 1
        if question.nextDate >= 0 && todayEnd >= question.nextDate { return true }
        return false
    }
    
    func trailingSwipeQuestion(swipedAnswer:RealmMindNodeModel){
        let nextIndex = self.optimizeIndex(answerNode:swipedAnswer)
        self.view?.answerTableView.reloadData()
        self.view?.answerTableView.selectRow(at: [0,nextIndex], animated: false, scrollPosition: .top)
        
        myModel.trailingSwipeQuestion(swipedAnswer: swipedAnswer)
        self.createQuestionLog(isCorrect:false,swipedAnswer: swipedAnswer)
        if self.goNextQuestionJudge() == true { self.nextQuestionButtonTapped() }
    }
    
    func changeToSelectedAnswerQuiz(tappedNode:RealmMindNodeModel){
        self.answerButtonEnabled()
        let nextQuestion:RealmMindNodeModel = myModel.mindNodeShared.getNodeByMapIdAndNodeId(mapId: tappedNode.mapId, nodeId: tappedNode.myNodeId)
        self.reloadQAPair(nextQuestion: nextQuestion)
    }
    
    private func setQuestionArray(questionArray: [RealmMindNodeModel]){
        self.quizDataSource = questionArray
    }
}


extension ToDoQuestionPresenter:UserDataModelDelegate{
    
    func syncUserData(user:User){
    }
    
    func didGetUserData(user: User) {
        self.userDisplayReload()
    }

    @objc func userModelUpdateDone(){
        let answerTimesLabel = self.view?.userDataDisplay.answerTimesLabel
        let scoreLabel = self.view?.userDataDisplay.scoreLabel
        UIView.transition(with: answerTimesLabel!,
                        duration: 0.5,
                          options: [.transitionFlipFromBottom, .curveEaseIn],
                          animations: {
        },
                          completion:  { (finished: Bool) in
                            answerTimesLabel!.text = String(self.user.totalAnswerTimes) + "times".localized
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
        self.displayingQustion = nextQuestion
        self.mapTitle = myModel.getMapTitle(question: nextQuestion) //get map title
        self.renderingView()
        self.quizDataSource.count > 0 ? self.changeToQuestionMode() : self.changeToCompleteMode()
        self.buttonEnabledControl()
        
    }
    
    private func setAnswerNodeArray(question:RealmMindNodeModel){
        var tempAnswerNodeArray = [RealmMindNodeModel]()
        for childNodeId in question.childNodeIdArray {
            let answerNode = myModel.mindNodeShared.getNodeByMapIdAndNodeId(mapId: question.mapId, nodeId: childNodeId.MindNodeChildId)
            tempAnswerNodeArray.append(answerNode)
        }
        self.answerNodeArray = tempAnswerNodeArray
        self.view?.answerTableView.reloadData()
    }
    
    func decideCellColor(answerNodeData:RealmMindNodeModel) -> UIColor{
        let lastAnswerdTime = answerNodeData.lastAnswerdTime
        if lastAnswerdTime > self.startQuestionTime.millisecondsSince1970 && self.betweenTodayRange(time: answerNodeData.nextDate) { return UIColor.orange } //already solved
        if lastAnswerdTime <= self.startQuestionTime.millisecondsSince1970 && self.betweenTodayRange(time: answerNodeData.nextDate){ return UIColor.white } //まだ説かれていない
        return UIColor.green
    }
        
    private func buttonEnabledControl(){
        if self.quizDataSource.count == 0{
            self.view?.buttonStackView.isHidden = true
            self.view?.buttonStackView.answerButton.isEnabled = false
            self.view?.buttonStackView.answerButton.alpha = 0.5
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
        self.view!.buttonStackView.isHidden = false
        self.view!.Correct_WrongStackView.isHidden = true
    }
    
    private func changeToAnswerMode(){
        UIView.transition(with: self.view!.customView, duration: 0.3, options: [.transitionCurlUp], animations: {
            self.view!.customView.isHidden = false
            self.view!.answerTableView.isHidden = true
        }, completion: { (finished: Bool) in
            self.view!.customView.isHidden = true
            self.view!.answerTableView.isHidden = false
        })
        self.view!.buttonStackView.isHidden = true
        self.view!.Correct_WrongStackView.isHidden = false
    }
    
    private func changeToCompleteMode(){
        view?.customView.isHidden = true
        view?.answerTableView.isHidden = true
        view?.buttonStackView.isHidden = true
        view?.noQuestionLabel.isHidden = false
    }
    
    func soundButtonTapped(){
        //judge
        let soundButtonImage = self.view?.customView.soundButton.currentImage
        if soundButtonImage == R.image.soundOn() {
            self.soundModeFinish()
        }else if soundButtonImage == R.image.soundOff(){
            self.soundModeStart()
        }
    }
    
    func soundModeStart(){
        //leadingSwipeQuestion all
        self.nextQuestionButtonTapped()
        self.setAnswerNodeArray(question: self.displayingQustion)
        self.view?.soundPlay(text: self.displayingQustion.content,isQuestion: true)
    }
    
    func answerPlay(){
        var answerNodeContent:String = ""
        for answerNode in self.answerNodeArray {
            answerNodeContent += answerNode.content
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view?.soundPlay(text: answerNodeContent,isQuestion: false)
        }
    }
    
    func nextSoundQuestion(){
        self.correctAllAnswer()
        self.nextQuestionButtonTapped()
        self.setAnswerNodeArray(question: self.displayingQustion)
        if (self.quizDataSource.count < 1) {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view?.soundPlay(text: self.displayingQustion.content,isQuestion: true)
        }
    }
    
    private func correctAllAnswer(){
        for answerNode in self.answerNodeArray {
            self.leadingSwipeQuestion(swipedAnswer: answerNode)
        }
    }
    
    private func soundModeFinish(){
        self.view?.talker.stopSpeaking(at: .immediate)
    }
    
    private func quizSubmitToFirestore(){
        myModel.quizSubmitToFirestore()
    }

}
//viewの更新関連
extension ToDoQuestionPresenter:QuestionModelPresenterProtocol{
    
    func syncData(allNodeData: [RealmMindNodeModel]) {
        //Qmodel → presenter同期
        self.quizDataSource = allNodeData
    }
    
    @objc func notifyToQuestionModelView() {
        print("notify model change update")
        self.buttonEnabledControl()
        self.view?.reloadQuestionModelView() //状態確認
        //FIX ここで呼び出すの適切じゃないと思う
        self.userDisplayReload()
        self.renderingView()
    }

    private func userDisplayReload(){  //一番上のユーザーの経験値とかのスコア情報
        let bunboTextLabel = self.view?.userDataDisplay.bunboLabel.text
        if let bunboText = bunboTextLabel {
            let bunboInt = NumberFormatter().number(from: bunboText)!.intValue
            self.view?.userDataDisplay.bunsiLabel.text = String( bunboInt - self.quizDataSource.count)
        }
        self.view?.userDataDisplay.levelLabel.text = "level." + String(self.user.level)
        self.view?.userDataDisplay.progressView.setProgress(self.experience, animated: true)
    }

    //TODO protocolに準拠させよう viewRenderingなprotocol
    private func renderingView(){
        self.view?.customView.questionLabel.text = self.displayingQustion.content.replacingOccurrences(of:"\t", with:"")
        self.view?.customView.mapTitleLabel.text = self.mapTitle
    }

}
