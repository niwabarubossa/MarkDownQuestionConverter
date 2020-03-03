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
        if index > self.quizDataSource.count {
            return false
        }else{
            return true
        }
    }

    func getQuestionFromModel(mapId:String){
        questionModel.getMapQuestion(mapId:mapId)
    }
    
    func didGetMapQuestion(question: Results<RealmMindNodeModel>){
        for item in question {
            self.quizDataSource.append(item)
        }
        self.changeQuiz(nodeId:0) //最初はタイトルからのクイズで
    }
    
    func changeQuiz(nodeId:Int){
        if self.quizDataSource.count > 0 {
            self.displayingQustion = selectNodeByNodeId(nodeId: nodeId)
            view?.changeQuizDisplay(questionNode: self.displayingQustion)
            self.changeToQuestionMode()
        }
    }
    
    func selectNodeByNodeId(nodeId:Int) -> RealmMindNodeModel{
        let selectedNode:RealmMindNodeModel = self.quizDataSource.filter({ $0.myNodeId == nodeId }).first ?? RealmMindNodeModel()
        return selectedNode
    }
    
    func changeToSelectedAnswerQuiz(row:Int){
        let searchNodeId = self.answerNodeArray[row].myNodeId
        let nextQuestionNode = self.quizDataSource.filter({ $0.myNodeId == searchNodeId }).first ?? RealmMindNodeModel()
        self.displayingQustion = nextQuestionNode
        view?.changeQuizDisplay(questionNode: self.displayingQustion)
        self.changeToQuestionMode()
    }
    
    private func changeToQuestionMode(){
        view?.customView.questionDisplayLabel.isHidden = false
        view?.questionAnswerTableView.isHidden = true
    }
    
    private func changeToAnswerMode(){
        view?.customView.questionDisplayLabel.isHidden = true
        view?.questionAnswerTableView.isHidden = false
    }
    
    private func initAnswerNodeArray(){
        self.answerNodeArray.removeAll()
    }
    
    func showAnswer(){
        initAnswerNodeArray()
        var answerArray = [String]()
        let answerNodeIdArray = self.displayingQustion.childNodeIdArray
        for answerNodeId in answerNodeIdArray {
            let nodeId = answerNodeId.MindNodeChildId
            let answerNode = self.quizDataSource.filter({ $0.myNodeId == nodeId }).first
            self.answerNodeArray.append(answerNode ?? RealmMindNodeModel())
            answerArray.append(answerNode?.content ?? "no answer")
        }
        view?.changeDisplayToAnswer(answerNodeArray: answerNodeArray)
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
