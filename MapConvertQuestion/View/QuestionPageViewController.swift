//
//  QuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class QuestionPageViewController: UIViewController {

    var presenter:QuestionPagePresenter!
    var customView = QuestionDidsplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
        getQuestion()
    }
    
    private func initializePresenter() {
       presenter = QuestionPagePresenter(view: self)
    }
    
    private func layout(){
        customView.center = self.view.center
        customView.delegate = self
        self.view.addSubview(customView)
    }
    
    private func getQuestion(){
        presenter.getTestQuestionFromModel()
    }
    
    //presenter ← view
    func notifyToPresenter(){
        presenter.myfunc()
    }
    
    //presenter → view
    func testfunc(){
        print("done from presenter function")
    }
    
    func changeQuizDisplay(question: String){
        self.customView.questionDisplayLabel.text = question
    }
    
    func changeQuizButtonTapped(){
        self.customView.questionDisplayLabel.isHidden = false
        self.customView.myStackView.isHidden = true
        presenter.changeQuiz()
    }
    
    func showAnswerButtonTapped(){
        self.customView.questionDisplayLabel.isHidden = true
        self.customView.myStackView.isHidden = false
        presenter.showAnswer()
    }
    
    func changeDisplayToAnswer(answer_array:[String]){
//        self.customView.questionDisplayLabel.text = answer
        //add arranged sub view

        for answer in answer_array {
            let answerButton = createAnswerUIButton(answer: answer)
            self.customView.myStackView.addArrangedSubview(answerButton)
        }
    }
    
    func createAnswerUIButton(answer:String) -> UIButton{
        let answerButton = UIButton()
        // 緑のビューの高さは、青のビューの高さと同じ大きさ
        answerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        answerButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        answerButton.setTitle(answer, for: .normal)
        return answerButton
    }

}
