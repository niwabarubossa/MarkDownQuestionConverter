//
//  ToDoQuestionModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import Foundation

protocol ToDoQuestionModelDelegate: class {
    func delegateFunc()
}

class ToDoQuestionModel {
    weak var delegate: ToDoQuestionModelDelegate?
    
    func toPresenterFromView(input:String){
        print("test function")
        self.delegate?.delegateFunc()
    }
}
