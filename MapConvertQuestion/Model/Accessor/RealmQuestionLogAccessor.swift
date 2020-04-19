//
//  RealmQuestionLogAccessor.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/19.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

class RealmQuestionLogAccessor {
    //使う時
//     let questionLogShared = RealmQuestionLogAccessor.sharedInstance
    static let sharedInstance = RealmQuestionLogAccessor()
    private init() {
    }
    
    func getWeeklyQuestionLog() -> [QuestionLog]{
        var allLogData = [QuestionLog]()
        let realm = try! Realm()
        let aWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let weekStart = Calendar.current.startOfDay(for: aWeekAgo!).millisecondsSince1970 - 1
        let results = realm.objects(QuestionLog.self).filter("date > %@",weekStart).filter("isCorrect == %@",true)
        for questionLog in results {
            allLogData.append(questionLog)
        }
        return allLogData
    }
    
    func getTodayQuestionLog() -> [QuestionLog]{
        var allLogData = [QuestionLog]()
        let realm = try! Realm()
        let todayStart = Calendar.current.startOfDay(for: Date()).millisecondsSince1970 - 1
        let results = realm.objects(QuestionLog.self).filter("date > %@", todayStart)
        for questionLog in results {
            allLogData.append(questionLog)
        }
        return allLogData
    }
    
    func getTodayDoneQuestionAmount() -> Int{
        let realm = try! Realm()
        let results = realm.objects(QuestionLog.self).filter(" date BETWEEN {\(LetGroup.todayStartMili), \(LetGroup.todayEndMili)}")
         var questionNodeIdArray = [String]()
        for questionLog in results  {
            if questionNodeIdArray.contains(questionLog.questionNodeId) == false {
                questionNodeIdArray.append(questionLog.questionNodeId)
            }
        }
        return questionNodeIdArray.count
    }
}
