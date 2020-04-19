//
//  ToDoDashboardModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/12.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
//----------model-------------------------------------------
import Foundation
import RealmSwift

protocol ToDoDashboardModelDelegate: class {
    func didGetTodayLogAmount(amount:Int) -> Void
}

class ToDoDashboardModel {
    weak var delegate: ToDoDashboardModelDelegate?
    
    let mindNodeShared = RealmMindNodeAccessor.sharedInstance
    let userShared = RealmUserAccessor.sharedInstance
    let questionLogShared = RealmQuestionLogAccessor.sharedInstance
    
    func registerUserQuota(){
        let user = userShared.getUserData()
        if self.isTodayFirstLogin(user:user) == true {
            self.updateUserQuota(user:user)
        }
    }
    
    private func isTodayFirstLogin(user:User) -> Bool{
        if LetGroup.todayStartMili > user.lastLogin { return true }
        return false
    }

    func getTodayLogAmount() -> Int{
        return questionLogShared.getTodayDoneQuestionAmount()
    }
    
    private func getToDoQuestionAmount() -> Int{
        let results = mindNodeShared.getToDoQuestion()
        return results.count
    }
    
    func updateUserQuotaFromPresenter(){
        let user = userShared.getUserData()
        if self.isTodayFirstLogin(user: user) == true {
            self.updateUserQuota(user: user)
        }
    }
    
    func updateUserQuota(user:User){
        let todayQuota = self.getToDoQuestionAmount()
        let updateKeyValueArray:[String:Any] = [
            "lastLogin":Date().millisecondsSince1970,
            "todayQuota":todayQuota
        ]
        userShared.updateUserData(updateKeyValueArray: updateKeyValueArray, updateUser: user)
    }
    
    func testfunc(){
        print("test func")
    }
    
    func toPresenterFromView(input:String){
        print("test function")
    }
}

extension ToDoDashboardModel:MVPModelProtocol{
    var notificationName: Notification.Name {
        return Notification.Name.toDoDashboardUpdate
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
