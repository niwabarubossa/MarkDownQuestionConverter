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
        let todayStart = Calendar.current.startOfDay(for: Date()).millisecondsSince1970
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let todayEnd = Calendar.current.startOfDay(for: tomorrow!).millisecondsSince1970 - 1
        let results = realm.objects(RealmMindNodeModel.self).filter("nextDate BETWEEN {0, \(todayEnd)}")
        print("results.count")
        print("\(results.count)")
        var questionArray = [RealmMindNodeModel]()
        for question in results {
            questionArray.append(question)
        }
        self.delegate?.didGetToDoQuestion(questionArray: questionArray)
    }
    
}
