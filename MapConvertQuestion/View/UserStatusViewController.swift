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
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.progress = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.progressView.setProgress(Float(0.00 + self.experienceDelta), animated: true)
            for _ in 0..<2{
                self.levelUpAnimation()
            }
        }
    }
}

extension UserStatusViewController{
    func levelUpAnimation() {
        // ①
        oneLevelUp(completionClosure: { (result:Int) in
            // ⑥ 10が返ってくる
            self.progressView.setProgress(Float(0.0), animated: false)
        })

        // ④
    }
    func oneLevelUp(completionClosure:@escaping CompletionClosure) {
        // ②

        UIView.animate(withDuration: 0.3, animations: {
          self.progressView.setProgress(Float(0.99), animated: true)
        }, completion: { (finished) in
            // ⑤
            // 終了した時、10という値を返す
            completionClosure(10)
        })
        // ③
    }
}
