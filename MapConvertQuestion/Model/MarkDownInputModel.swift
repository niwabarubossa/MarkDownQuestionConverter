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
    
    func submitInput(input:String){
        print("submit input")
        //realm処理
        let inputLineArray = convertInputToLines(input:input)
        let _:[MindNode] = convertStringLinesToMindNode(inputArray:inputLineArray)
        let test_data = QuestionStruct(question: "test_question", answer_array: ["asnwer1","answer2"], score: 0)
        saveToRealm(data: test_data)
        self.delegate?.didSubmitInput()
    }
    
    private func convertInputToLines(input:String) ->[String]{
        //テキストを行ごとに
        let inputLineArray:[String] = ["line1","line2"]
        //変換処理
        return inputLineArray
    }
    
    private func convertStringLinesToMindNode(inputArray:[String]) -> [MindNode]{
        let mindNodeGroup:[MindNode] = [
            MindNode(myNodeId: 0, content: "test", parentNodeId: 0, childNodeIdArray: [000]),
            MindNode(myNodeId: 0, content: "test", parentNodeId: 0, childNodeIdArray: [000])
        ]
        //変換処理
        return mindNodeGroup
    }
    
    private func saveToRealm(data: QuestionStruct){
        
    }
}
