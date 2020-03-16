//
//  RootTabBarController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/15.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import RealmSwift

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["FirstLaunch" : true])
        if defaults.bool(forKey: "FirstLaunch") == true {
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
            let new_uuid = NSUUID().uuidString
            UserDefaults.standard.set(new_uuid, forKey: "uuid")
             print("new!! \n \(new_uuid) \n\n")
            print("初回のログインです")
            self.createUserData(uuid:new_uuid)
            let howToVC = R.storyboard.settings.howToPage()
            self.present(howToVC!, animated: true, completion: nil)
        }else{
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
            print("２回目以降のログインです")
        }
    }
    
    private func createUserData(uuid:String){
        do {
            let realm = try Realm()
            let user = User(value: [
                "uuid": uuid
            ])
            try! realm.write {
                realm.add(user)
                print("成功", user)
            }
        } catch {
            print("\(error)")
            print("エラーだよ")
        }
    }
}
