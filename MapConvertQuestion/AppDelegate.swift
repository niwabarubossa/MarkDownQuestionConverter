//
//  AppDelegate.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/16.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? // これを追加
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
        }
        
        let migSchemaVersion: UInt64 = 15
        let config = Realm.Configuration(
            schemaVersion: migSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < migSchemaVersion) {
        }})
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return true
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

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

