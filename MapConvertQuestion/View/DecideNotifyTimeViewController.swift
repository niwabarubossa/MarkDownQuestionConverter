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
    private func testNotify(dateComponent:DateComponents){
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "復習"
        content.subtitle = "lets study!"
        content.body = "設定した復習の時間です!"
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
