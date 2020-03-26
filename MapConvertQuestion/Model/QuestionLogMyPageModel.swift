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
    func didGetWeeklyQuestionLog(questionLogs: [QuestionLog]) -> Void
}

protocol MVPModelProtocol: class {
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
    func notifyToPresenter()
}

class QuestionLogModel {
    weak var delegate: QuestionLogModelDelegate?
    
    func getWeeklyQuestionLog(mapId:String){
        var allLogData = [QuestionLog]()
        let realm = try! Realm()
        let results = realm.objects(QuestionLog.self).filter("mapId == %@", mapId)
        for questionLog in results {
            allLogData.append(questionLog)
        }
        self.delegate?.didGetWeeklyQuestionLog(questionLogs: allLogData)
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