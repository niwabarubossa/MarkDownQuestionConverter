//
//  ToDoQuestionPresenter.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import Foundation
import UIKit

class ToDoQuestionPresenter:ToDoQuestionModelDelegate{

    //自分用のモデルの宣言
    let myModel: ToDoQuestionModel
    //オリジナルのクラス型にすること
    weak var view:ToDoQuestionPageViewController?

    init(view: ToDoQuestionPageViewController) {
        self.view = view
        self.myModel = ToDoQuestionModel()
        myModel.delegate = self
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
    }
    
    func nextQuestionButtonTapped(){
        print("nextQuestionButtonTapped in presenter")
    }
    
    func didGetToDoQuestion(questionArray: [RealmMindNodeModel]) {
        print("questionArray")
    }
}
