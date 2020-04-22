//
//  UserStatusViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class UserStatusViewController: UIViewController {

    @IBOutlet weak var testScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        testScoreLabel.text = "0"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1.0) {
//            self.testScoreLabel.text = "asd"
        }
    }



}
