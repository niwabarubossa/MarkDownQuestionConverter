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
    func didInitViewController() -> Void
    func didGetUserData(user:User) -> Void
}

class ToDoDashboardModel {
    weak var delegate: ToDoDashboardModelDelegate?
    
    func initViewController(){
        self.delegate?.didInitViewController()
    }
    
    func getUserData(){
        let realm = try! Realm()
        if let user = realm.objects(User.self).first{
            self.delegate?.didGetUserData(user:user)
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
