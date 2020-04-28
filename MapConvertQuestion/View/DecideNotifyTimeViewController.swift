//
//  DecideNotifyTimeViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

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
                    self.testNotify()
              } else { print("通知拒否") }
          })
      } else { // iOS 9以下
          let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
          UIApplication.shared.registerUserNotificationSettings(settings)
      }
    }
    
    private func testNotify(){
        var notificationTime = DateComponents()
        var trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        content.title = "お知らせ"
        content.body = "ボタンを押しました。"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension DecideNotifyTimeViewController:NotifyTimeDecideViewDelegate{
    func submitButtonTapped() {
        self.getNotificationGrant()
    }
}
