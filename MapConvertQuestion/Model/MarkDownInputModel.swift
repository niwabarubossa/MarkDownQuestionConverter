//
//  MarkDownInputModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/20.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation

protocol MarkDownInputModelDelegate: class {
    func didSubmitInput()
}

class MarkDownInputModel {
    weak var delegate: MarkDownInputModelDelegate?
    
    func submitInput(){
        print("submit input")
        self.delegate?.didSubmitInput()
    }
}
