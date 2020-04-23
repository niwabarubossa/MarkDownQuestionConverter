//
//  UserStatusViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class UserStatusViewController: UIViewController {

    var experienceDelta = 0.01
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.progress = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.progressView.setProgress(Float(0.00 + self.experienceDelta), animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.progressView.setProgress(Float(0.00 + self.experienceDelta), animated: true)
        }
    }



}
