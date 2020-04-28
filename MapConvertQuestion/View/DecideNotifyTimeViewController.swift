//
//  DecideNotifyTimeViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import UserNotifications

class DecideNotifyTimeViewController: UIViewController {

    @IBOutlet weak var decideNotifyTimeView: NotifyTimeDecideView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decideNotifyTimeView.delegate = self
    }
}

extension DecideNotifyTimeViewController:UNUserNotificationCenterDelegate{
    private func getNotificationGrant(){
       if #available(iOS 10.0, *) {
          // iOS 10
          let center = UNUserNotificationCenter.current()
          center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
              if error != nil { return }
              if granted {
                  print("通知許可")
                  let center = UNUserNotificationCenter.current()
                  center.delegate = self
              } else { print("通知拒否") }
          })
      } else { // iOS 9以下
          let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
          UIApplication.shared.registerUserNotificationSettings(settings)
      }
    }
    
    private func testNotify(dateComponent:DateComponents){
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "ローカル通知テスト"
        content.subtitle = "日時指定"
        content.body = "日時指定によるタイマー通知です"
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let identifier = NSUUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension DecideNotifyTimeViewController:NotifyTimeDecideViewDelegate{
    func submitButtonTapped(dateComponent:DateComponents) {
//        self.getNotificationGrant()
        self.testNotify(dateComponent:dateComponent)
    }
}
