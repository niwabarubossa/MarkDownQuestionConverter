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
    func didGetUserData(user:User) -> Void
    func didGetTodayLogAmount(amount:Int) -> Void
}

class ToDoDashboardModel {
    weak var delegate: ToDoDashboardModelDelegate?
    
    let mindNodeShared = RealmMindNodeAccessor.sharedInstance
    
    func registerUserQuota(){
        let user = self.getUserData()
        if self.isTodayFirstLogin(user:user) == true {
            self.updateUserQuota(user:user)
        }
    }
    
    func getUserData() -> User{
        let realm = try! Realm()
        if let user = realm.objects(User.self).first{
            self.delegate?.didGetUserData(user:user)
            return user
        }
        return User()
    }
    
    private func isTodayFirstLogin(user:User) -> Bool{
        if LetGroup.todayStartMili > user.lastLogin { return true }
        return false
    }

    func getTodayLogAmount() -> Int{
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
    
    private func getToDoQuestionAmount() -> Int{
        let results = mindNodeShared.getTodayAnswer()
        var questionArray = [RealmMindNodeModel]()
        var alreadyExist = [String]()
        for answerNode in results {
            let question:RealmMindNodeModel = mindNodeShared.getNodeByMapIdAndNodeId(mapId:answerNode.mapId,nodeId: answerNode.parentNodeId)
            if question.myNodeId != question.parentNodeId {
                if alreadyExist.contains(question.nodePrimaryKey) == false{
                    questionArray.append(question)
                    alreadyExist.append(question.nodePrimaryKey)
                }
            }
        }
        return questionArray.count
    }
    
    func updateUserQuotaFromPresenter(){
        let user = self.getUserData()
        if self.isTodayFirstLogin(user: user) == true {
            self.updateUserQuota(user: user)
        }
    }
    
    func updateUserQuota(user:User){
        let todayQuota = self.getToDoQuestionAmount()
        do{
            let realm = try Realm()
            try! realm.write {
                user.setValue(Date().millisecondsSince1970, forKey: "lastLogin")
                user.setValue(todayQuota, forKey: "todayQuota")
            }
        }catch{
            print("\(error)")
        }
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
