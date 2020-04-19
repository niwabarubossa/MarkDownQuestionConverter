//
//  RealmUserAccessor.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/19.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUserAccessor {
    static let sharedInstance = RealmUserAccessor()
    private init() {
    }
    
    func getUserData() -> User{
        let realm = try! Realm()
        if let user = realm.objects(User.self).first{
            return user
        }
        return User()
    }
    
}
