//
//  QuestionPagePresenter.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import Foundation
import UIKit

class QuestionPagePresenter:QuestionModelDelegate{
    //自分用のモデルの宣言
    let questionModel: QuestionModel
    var quizDataSource = [QuestionStruct]()
    var displayingQustion:QuestionStruct = QuestionStruct(question: "", answer_array: [], score: 0)
    
    //オリジナルのクラス型にすること
    weak var view: QuestionPageViewController?

    init(view: QuestionPageViewController) {
        self.view = view
        self.questionModel = QuestionModel()
        questionModel.delegate = self
    }

    func signUpButtonTapped() {
        // Presenter → Model
        questionModel.testfunc()
    }

    func loginButtonTapped() {
        //Presenter → View の操作
        view?.testfunc()
    }

    func myfunc() {
        print("notify from view")
    }
    
    func getTestQuestionFromModel(){
        questionModel.createTestQuestion()
    }
    
    func didGetTestQuestionFromModel(question: [QuestionStruct]){
        self.quizDataSource = question
        self.changeQuiz()
    }
    
    func renderingQuizData(question: [QuestionStruct]){
        let randomInt = Int.random(in: 0..<self.quizDataSource.count)
        view?.changeQuizDisplay(question: self.quizDataSource[randomInt].question)
    }
    
    func changeQuiz(){
        let randomInt = Int.random(in: 0..<self.quizDataSource.count)
        self.displayingQustion = quizDataSource[randomInt]
        let questionWithTab = self.displayingQustion.question
        view?.changeQuizDisplay(question: questionWithTab.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    func showAnswer(){
        let answer = displayingQustion.answer_array.joined(separator: "\n")
        view?.changeDisplayToAnswer(answer: answer)
    }
    
    
}

