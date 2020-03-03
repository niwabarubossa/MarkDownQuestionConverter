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
            
    func getMapQuestion(mapId:String){
        let realm = try! Realm()
        let allQuestionNodeArray = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", mapId)
        self.delegate?.didGetMapQuestion(question: allQuestionNodeArray)
    }
    
    func updateMapQuestion(learningIntervalStruct:LearningIntervalStruct,focusNode:RealmMindNodeModel){
        let realm = try! Realm()
        let focusNode = realm.objects(RealmMindNodeModel.self).filter("mapId == %@", focusNode.mapId).filter("myNodeId == %@", focusNode.myNodeId).first

        try! realm.write {
        focusNode?.setValue(learningIntervalStruct.ifSuccessNextInterval, forKey: "ifSuccessInterval")
        
            focusNode?.setValue(learningIntervalStruct.nextLearningDate, forKey: "nextDate")
        }
    }
}
