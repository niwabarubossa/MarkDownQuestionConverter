//
//  QuestionLogMyPageModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/25.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

//----------model-------------------------------------------
import Foundation
import RealmSwift

protocol QuestionLogModelDelegate: class {
    func modelDelegateFunc() -> Void
    func didGetQuestionLog(questionLogs: [QuestionLog]) -> Void
}

protocol MVPModelProtocol: class {
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
    func notifyToPresenter()
}

class QuestionLogModel {
    weak var delegate: QuestionLogModelDelegate?
    let userShared = RealmUserAccessor.sharedInstance
    var user:User{
        userShared.getUserData()
    }

    func getWeeklyQuestionLog(){
        var allLogData = [QuestionLog]()
        let realm = try! Realm()
        let aWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let weekStart = Calendar.current.startOfDay(for: aWeekAgo!).millisecondsSince1970 - 1
        let results = realm.objects(QuestionLog.self).filter("date > %@",weekStart).filter("isCorrect == %@",true)
        for questionLog in results {
            allLogData.append(questionLog)
        }
        self.delegate?.didGetQuestionLog(questionLogs: allLogData)
    }
        
    func getTodayQuestionLog(){
        var allLogData = [QuestionLog]()
        let realm = try! Realm()
        let todayStart = Calendar.current.startOfDay(for: Date()).millisecondsSince1970 - 1
        let results = realm.objects(QuestionLog.self).filter("date > %@", todayStart)
        for questionLog in results {
            allLogData.append(questionLog)
        }
        self.delegate?.didGetQuestionLog(questionLogs: allLogData)
    }

    
    private func calculateBeforeWeek() -> Date{
        let sevenDaysBefore = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let weekBegin = Calendar.current.startOfDay(for: sevenDaysBefore!)
        return weekBegin
    }

    func testfunc(){
        print("test func")
    }
    
    func toPresenterFromView(input:String){
        print("test function")
        self.delegate?.modelDelegateFunc()
    }
}

extension QuestionLogModel:MVPModelProtocol{
    var notificationName: Notification.Name {
        return Notification.Name.questionLogModelUpdate
     }
    
    func notifyToPresenter() {
        NotificationCenter.default.post(name: notificationName, object:nil)
    }

    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}

//----------model------------------------------------
