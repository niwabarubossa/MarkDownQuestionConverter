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
    
    func getUserData(){
        print("test function")
        let realm = try! Realm()
        if let user = realm.objects(User.self).first{
            self.delegate?.didGetUserData(user:user)
        }
    }
    
    func updateUserData(){
        //update処理
        self.notify()
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
        NotificationCenter.default.post(name: self.notificationName, object:nil)
    }
    
    func addObserver(_ obserber: Any, selector: Selector) {
        NotificationCenter.default.addObserver(obserber, selector: selector, name: self.notificationName, object: nil)
    }
}
