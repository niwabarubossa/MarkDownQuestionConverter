//
//  QuestionModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation

protocol QuestionModelDelegate: class {
    func myfunc()
    func didGetTestQuestionFromModel(question:[QuestionStruct])
}

class QuestionModel {
    weak var delegate: QuestionModelDelegate?
    
    func testfunc(){
        self.delegate?.myfunc()
    }
    
    func createTestQuestion(){
        let testQuestionArray:[QuestionStruct] = [
            QuestionStruct(question: "Q1", answer_array: ["answer1","asnwe2","ane2"], score: 0),
            QuestionStruct(question: "Q22222", answer_array: ["answer1","asnwe2","ane2"], score: 0),
            QuestionStruct(question: "hello world", answer_array: ["answer1","asnwe2","ane2"], score: 0),
            QuestionStruct(question: "this is me ", answer_array: ["answer1","asnwe2","ane2"], score: 0),
            QuestionStruct(question: "wawawaawa", answer_array: ["answer1","asnwe2","ane2"], score: 0),
            QuestionStruct(question: "waas;ldkj", answer_array: ["answer1","asnwe2","ane2"], score: 0),
        ]
        self.delegate?.didGetTestQuestionFromModel(question: testQuestionArray)
    }
    
}
