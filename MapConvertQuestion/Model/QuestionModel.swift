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
    func didGetMapQuestion(question:Results<RealmMindNodeModel>)
}

class QuestionModel {
    weak var delegate: QuestionModelDelegate?
    
    let testMindNodeArray:[MindNode] = [
        MindNode(myNodeId: 3, content: "\t\t\t2", parentNodeId: 2, childNodeIdArray: [])
    ]
        
    func getMapQuestion(mapId:String){
        let realm = try! Realm()
        let allQuestionNodeArray = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId)
        self.delegate?.didGetMapQuestion(question: allQuestionNodeArray)
    }
    
    private func getAnswer(nodeId:Int) -> String{
        let index = testMindNodeArray.firstIndex(where: { $0.myNodeId == nodeId })
        let answer = testMindNodeArray[index ?? 0].content
        return answer
    }
    
}
