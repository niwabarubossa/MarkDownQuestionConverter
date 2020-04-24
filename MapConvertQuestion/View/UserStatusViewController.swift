//
//  UserStatusViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class UserStatusViewController: UIViewController {
    typealias CompletionClosure = ((_ result:Int) -> Void)
    var experienceDelta = 0.01
    
    @IBOutlet weak var timeBarBaseView: UIView!
    var timeBarView = UIView()
    private var timeBarViewWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeBarView.frame = CGRect(x: 0, y: 0, width: 0, height: timeBarBaseView.frame.size.height)
        timeBarView.backgroundColor = UIColor.blue
        timeBarViewWidth = self.timeBarView.frame.size.width
        timeBarBaseView.addSubview(self.timeBarView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for i in 1..<4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) ) {
                self.levelUpUI(count:i)
            }
        }
    }
    
    private func levelUpUI(count:Int){
        self.timeBarView.frame = CGRect(x: 0, y: 0, width: 0, height: self.timeBarBaseView.frame.size.height)
        UIView.animate(withDuration: 0.8, delay: 0.0 , options: [.curveLinear], animations: {
            self.timeBarView.frame = CGRect(x: self.timeBarView.frame.minX, y:  self.timeBarView.frame.minY, width: self.timeBarBaseView.frame.size.width, height: self.timeBarView.frame.size.height)
            },
            completion: nil
        )
    }
}

