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

    func getQuestionFromModel(mapId:String){
        questionModel.getMapQuestion(mapId:mapId)
    }
    
    func didGetMapQuestion(question: Results<RealmMindNodeModel>){
        for item in question {
            self.quizDataSource.append(item)
        }
        self.changeQuiz()
    }
    
    func renderingQuizData(question: [QuestionStruct]){
        let randomInt = Int.random(in: 0..<self.quizDataSource.count)
        view?.changeQuizDisplay(question: self.quizDataSource[randomInt].content)
    }
    
    func changeQuiz(){
        let randomInt = Int.random(in: 0..<self.quizDataSource.count)
        self.displayingQustion = quizDataSource[randomInt]
        let questionWithTab = self.displayingQustion.content
        view?.changeQuizDisplay(question: questionWithTab.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    func changeToSelectedAnswerQuiz(row:Int){
        let searchNodeId = self.answerNodeArray[row].myNodeId
        let nextQuestionNode = self.quizDataSource.filter({ $0.myNodeId == searchNodeId }).first ?? RealmMindNodeModel()
        self.displayingQustion = nextQuestionNode
        let questionWithTab = self.displayingQustion.content
        view?.changeQuizDisplay(question: questionWithTab.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        view?.changeToQuestionMode()
    }
    
    private func initAnswerNodeArray(){
        self.answerNodeArray.removeAll()
    }
    
    func showAnswer(){
        initAnswerNodeArray()
        var answerArray = [String]()
        let answerNodeIdArray = displayingQustion.childNodeIdArray
        for answerNodeId in answerNodeIdArray {
            let nodeId = answerNodeId.MindNodeChildId
            let answerNode = self.quizDataSource.filter({ $0.myNodeId == nodeId }).first
            self.answerNodeArray.append(answerNode ?? RealmMindNodeModel())
            answerArray.append(answerNode?.content ?? "no answer")
        }
        view?.changeDisplayToAnswer(answer_array: answerArray)
    }
    
}
