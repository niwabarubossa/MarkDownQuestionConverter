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

class UserDataModel {
    weak var delegate: UserDataModelDelegate?
    
    func getUserData(){
        print("test function")
        let realm = try! Realm()
        if let user = realm.objects(User.self).first
        {
            self.delegate?.didGetUserData(user:user)
        }
    }
}
