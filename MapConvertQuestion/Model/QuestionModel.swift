//
//  Question.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/16.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation

struct QuestionData{
    var question:String
    var answer_array:[String]
    var score:Int
    init(question:String,answer_array:[String],score:Int){
        self.question = question
        self.answer_array = answer_array
        self.score = score
    }
}
