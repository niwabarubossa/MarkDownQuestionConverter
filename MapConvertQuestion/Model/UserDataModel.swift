//
//  UserDataModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/11.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserDataModelDelegate: class {
    func didGetUserData(user:User) -> Void
    func syncUserData(user:User)
}

protocol UserDataModelViewProtocol: class {
    func reloadUserDataModelView()
}

protocol UserDataModelProtocol: ModelProtocolNotify {
    func fetchControl() //最後は必ず self.notify(post notification)を呼ぶこと
}

protocol ModelProtocolNotify: class {
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
}

class UserDataModel {
    weak var delegate: UserDataModelDelegate?
    var user = User()
    
    func setUser(user: User){
        self.user = user
    }
    
    func getUserData(){
        print("test function")
        let realm = try! Realm()
        if let user = realm.objects(User.self).first{
            self.delegate?.didGetUserData(user:user)
            self.user = user
        }
    }
    
    func updateUserData(swipedAnswer:RealmMindNodeModel){
        self.createQuestionLog(swipedAnswer:swipedAnswer)
        let user = self.updateUserScore(swipedAnswer:swipedAnswer)
        self.setUser(user: user)
        self.notify()
    }
    
    private func createQuestionLog(swipedAnswer:RealmMindNodeModel){
        print("createQuestionLog")
    }
    
    private func updateUserScore(swipedAnswer:RealmMindNodeModel) ->User{
        let charactersCount = Int64(swipedAnswer.content.replacingOccurrences(of:"\t", with:"").count)
        do{
            let realm = try Realm()
            try! realm.write {
                self.user.setValue(user.totalAnswerTimes + 1, forKey: "totalAnswerTimes")
                self.user.setValue(user.totalCharactersAmount + charactersCount, forKey: "totalCharactersAmount")
            }
        }catch{
            print("\(error)")
        }
        return self.user
    }
    
    func fetchControl(){
// notificatino のpostを呼ぶ
        self.notify()
    }
}

extension UserDataModel: UserDataModelProtocol {
    var notificationName: Notification.Name {
        return Notification.Name.userModelUpdate
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    func notify() {
        self.delegate?.syncUserData(user: self.user)
        NotificationCenter.default.post(name: self.notificationName, object:nil)
    }
    
    func addObserver(_ obserber: Any, selector: Selector) {
        NotificationCenter.default.addObserver(obserber, selector: selector, name: self.notificationName, object: nil)
    }
}
