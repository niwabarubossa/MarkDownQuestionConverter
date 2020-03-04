//
//  ToDoQuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import UIKit

class ToDoQuestionPageViewController: UIViewController,ToDoQuestionDisplayDelegate {

    var presenter:ToDoQuestionPresenter!
    let customView = ToDoQuestionDisplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        // Do any additional setup after loading the view.
        layout()
    }
    
    private func layout(){
        customView.center = self.view.center
        customView.myDelegate = self
        self.view.addSubview(customView)
    }
    
    func answerButtonTapped() {
        print("answerButtonTapped")
        presenter.answerButtonTapped()
    }
    
    func nextQuestionButtonTapped(){
        print("nextQuestionButtonTapped")
        presenter.nextQuestionButtonTapped()
    }

    private func initializePresenter() {
       presenter = ToDoQuestionPresenter(view: self)
    }
    
    //presenter → view
    func testfunc(){
        print("done from presenter function")
    }

}

protocol ToDoQuestionDisplayDelegate {
    func answerButtonTapped() -> Void
    func nextQuestionButtonTapped() -> Void
}
