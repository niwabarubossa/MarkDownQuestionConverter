//
//  DecideNotifyTimeViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class DecideNotifyTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

}

extension DecideNotifyTimeViewController:NotifyTimeDecideViewDelegate{
    func submitButtonTapped() {
        self.getNotificationGrant()
    }
}
