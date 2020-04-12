//
//  ToDoDashboardViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/12.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ToDoDashboardViewController: UIViewController {

    
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        progressView.value = 0
        progressView.maxValue = 30
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1.0) {
            self.progressView.value = 15
        }
    }
}



