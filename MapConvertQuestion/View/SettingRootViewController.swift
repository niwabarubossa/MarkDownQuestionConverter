//
//  SettingRootViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/15.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class SettingRootViewController: UIViewController {

    @IBOutlet weak var howToLabel: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.howToLabel.addGestureRecognizer((UITapGestureRecognizer(target: self, action: Selector("howToLabelTapped:"))))
    }

    @objc private func howToLabelTapped(_ sender:UIButton){
        self.performSegue(withIdentifier: R.segue.settingRootViewController.goToHowToPage, sender: nil)
    }

}
