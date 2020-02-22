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
}

class QuestionModel {
    weak var delegate: QuestionModelDelegate?
    
    func testfunc(){
        self.delegate?.myfunc()
    }
}
