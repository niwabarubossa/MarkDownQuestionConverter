//
//  ToDoQuestionModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import Foundation
import RealmSwift

protocol ToDoQuestionModelDelegate: class {
    func didGetToDoQuestion(questionArray: [RealmMindNodeModel])
}

class ToDoQuestionModel {
    weak var delegate: ToDoQuestionModelDelegate?
    
    func toPresenterFromView(input:String){
        print("test function")
    }
    
    func getToDoQuestion(){
        let realm = try! Realm()
        let results = realm.objects(RealmMindNodeModel.self)
        //filter  user have to solve for today
        var questionArray = [RealmMindNodeModel]()
        for question in results {
            questionArray.append(question)
        }
        self.delegate?.didGetToDoQuestion(questionArray: questionArray)
    }
    
}
