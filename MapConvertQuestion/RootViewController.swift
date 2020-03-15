//
//  RootViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/15.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import RealmSwift

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //ここでhanteisuru
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["FirstLaunch" : true])
        if defaults.bool(forKey: "FirstLaunch") == true {
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
            let new_uuid = NSUUID().uuidString
            UserDefaults.standard.set(new_uuid, forKey: "uuid")
             print("new!! \n \(new_uuid) \n\n")
            print("初回のログインです")
            self.createUserData(uuid:new_uuid)
        }else{
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
            print("２回目以降のログインです")
            let howToVC = R.storyboard.settings.howToPage()
            self.present(howToVC!, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
