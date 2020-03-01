//
//  QuestionModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

protocol QuestionModelDelegate: class {
    func myfunc()
    func didGetTestQuestionFromModel(question:[QuestionStruct])
}

class QuestionModel {
    weak var delegate: QuestionModelDelegate?
    
    let testMindNodeArray:[MindNode] = [
        MindNode(myNodeId: 3, content: "\t\t\t2", parentNodeId: 2, childNodeIdArray: []),
        MindNode(myNodeId: 2, content: "\t\t1＋1＝", parentNodeId: 1, childNodeIdArray: [3]),
        MindNode(myNodeId: 5, content: "\t\t\t4", parentNodeId: 4, childNodeIdArray: []),
        MindNode(myNodeId: 4, content: "\t\t2＋2 ＝", parentNodeId: 1, childNodeIdArray: [5]),
        MindNode(myNodeId: 1, content: "\tすうがく", parentNodeId: 0, childNodeIdArray: [2, 4]),
        MindNode(myNodeId: 8, content: "\t\t\t力", parentNodeId: 7, childNodeIdArray: []),
        MindNode(myNodeId: 7, content: "\t\t　ちからをかんじで？", parentNodeId: 6, childNodeIdArray: [8]),
        MindNode(myNodeId: 6, content: "\tこくご", parentNodeId: 0, childNodeIdArray: [7]),
        MindNode(myNodeId: 0, content: "たいとる", parentNodeId: 0, childNodeIdArray: [1, 6])
    ]
    
    func testfunc(){
        self.delegate?.myfunc()
    }
    
    
    func createTestQuestion(){
        var testQuestionArray = [QuestionStruct]()
        for node in testMindNodeArray {
            let answerArray =  getAnswerArray(childNodeIdArray: node.childNodeIdArray)
            let question = QuestionStruct(question: node.content, answer_array: answerArray, score: 0)
            testQuestionArray.append(question)
        }
        self.delegate?.didGetTestQuestionFromModel(question: testQuestionArray)
    }
    
    private func getAnswerArray(childNodeIdArray:[Int]) ->[String]{
        var answerArray = [String]()
        for index in childNodeIdArray {
            let answer = getAnswer(nodeId: index)
            answerArray.append(answer)
        }
        return answerArray
    }
    
    private func getAnswer(nodeId:Int) -> String{
        let index = testMindNodeArray.firstIndex(where: { $0.myNodeId == nodeId })
        let answer = testMindNodeArray[index ?? 0].content
        return answer
    }
    
}
