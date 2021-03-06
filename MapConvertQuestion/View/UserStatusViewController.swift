//
//  UserStatusViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class UserStatusViewController: UIViewController {
    
    var expDelta:Double = 0 //代入される
    
    var howManyLevelUp:Int{
        let nowExp = CGFloat(self.user.totalCharactersAmount)
        return Int(self.getLevel(exp: Double(nowExp)) - self.getLevel(exp: Double(nowExp) - expDelta))
    }
    var nowExp :Double{
        return Double(self.user.totalCharactersAmount)
    }
    
    private var updatedUserLevel = 68 //代入される
    private var beforeLevel = 30 // user.level - howManyLevelUp
    private var displayLevel = 0
    private var tempLebel = 0
    private var user:User = RealmUserAccessor.sharedInstance.getUserData()

    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var timeBarBaseView: UIView!
    @IBOutlet weak var experienceLabel: UILabel!
    var timeBarView = UIView()
    private var timeBarViewWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeBarView.isHidden = true
        timeBarView.frame = CGRect(x: 0, y: 0, width: 0.0, height: timeBarBaseView.frame.size.height)
        timeBarBaseView.layer.cornerRadius = 15 / 2
        timeBarView.layer.cornerRadius = 15 / 2
        timeBarView.backgroundColor = UIColor.orange
        timeBarBaseView.addSubview(self.timeBarView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.experienceLabel.text = String(self.user.totalCharactersAmount) + "(+" + String(self.expDelta) + ")"
        self.displayLevel = Int(self.user.level) - self.howManyLevelUp
        self.displayLabel.text = String(self.displayLevel)
        let bunboExpDesu = CGFloat(getNeedExpAmount(level: Int(user.level) + 1))  - CGFloat(getNeedExpAmount(level: Int(user.level)))
        let endPercent:CGFloat = CGFloat( ( CGFloat(self.nowExp) - CGFloat(getNeedExpAmount(level: Int(user.level))) ) / bunboExpDesu )
                
        self.beforeLevel = Int(self.user.level) - self.howManyLevelUp
        let bunboExp:CGFloat = CGFloat(self.getNeedExpAmount(level: beforeLevel + 1)) -  CGFloat(self.getNeedExpAmount(level: beforeLevel))
        let tempUserAllExp = CGFloat(self.user.totalCharactersAmount)
        let beforeExp:CGFloat = tempUserAllExp - CGFloat(self.expDelta)
        let bunsiExp:CGFloat = beforeExp - CGFloat(self.getNeedExpAmount(level: beforeLevel))
        let startPercent:CGFloat = CGFloat((bunsiExp / bunboExp))
        self.setupExpBar(startPercent:startPercent)

        if howManyLevelUp > 1 {
            var totalTime:Int = 0
            for i in 1...howManyLevelUp {
                totalTime += i
                timeBarView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) ) {
                    if i == 1 {
                        self.levelUpUI(count:i,start:startPercent)
                    }else{
                        self.levelUpUI(count:i,start:0)
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalTime) + 1.0 ) {
                self.progressAnimationFromTo(start: 0, end: endPercent)
            }
        }else if howManyLevelUp == 1 {
            timeBarView.isHidden = false
            self.levelUpUI(count:1,start:startPercent)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
                self.progressAnimationFromTo(start: 0, end: endPercent)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
                self.timeBarView.isHidden = false
                self.progressAnimationFromTo(start: startPercent, end: endPercent)
            }
        }
    }
    
    private func setupExpBar(startPercent:CGFloat){
        timeBarViewWidth = startPercent * timeBarBaseView.frame.size.width
        timeBarView.isHidden = false
        timeBarView.frame = CGRect(x: 0, y: 0, width: timeBarViewWidth, height: timeBarBaseView.frame.size.height)
    }
    
    private func levelUpUI(count:Int,start: CGFloat){
        let startWidth = start * self.timeBarBaseView.frame.size.width
        self.timeBarView.frame = CGRect(x: 0, y: 0, width: startWidth, height: self.timeBarBaseView.frame.size.height)
        UIView.animate(withDuration: 0.8, delay: 0.0 , options: [.curveLinear], animations: {
            self.timeBarView.frame = CGRect(x: self.timeBarView.frame.minX, y:  self.timeBarView.frame.minY, width: self.timeBarBaseView.frame.size.width, height: self.timeBarView.frame.size.height)
            },
            completion: { (finished) in
                self.timeBarView.frame = CGRect(x: self.timeBarView.frame.minX, y:  self.timeBarView.frame.minY, width: 0, height: self.timeBarView.frame.size.height)
                self.displayLevel += 1
                self.displayLabel.text = String(self.displayLevel)
            }
        )
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UserStatusViewController{
    func getLevel(exp:Double) -> Int{
        var temp:Double = (exp + 300.0) / 330.0
        var level:Int = 0
        while temp >= 1.0 {
            temp = temp / 1.10
            level += 1
        }
      return level
    }

    
    func getNeedExpAmount(level:Int) -> Int{
        if level <= 0 { return 0 }
        if level == 1 { return 30 }
        var nextExpAmount = 30.0
        var ruijou_1_1 = 1.0
        for _ in 1..<level {
            ruijou_1_1 = ruijou_1_1 * 1.1 // 1.1^n-1
            nextExpAmount = (330 * ruijou_1_1) - 270
        }
        return Int(nextExpAmount)
    }

    private func progressAnimationFromTo(start:CGFloat,end:CGFloat){
        let baseView = self.timeBarBaseView
        let startWidth =  start * (baseView?.frame.size.width ?? 0)
        self.timeBarView.frame = CGRect(x: self.timeBarView.frame.minX, y:  self.timeBarView.frame.minY, width: startWidth, height: self.timeBarView.frame.size.height)
        let finishWidth =  end * (baseView?.frame.size.width ?? 0)
        UIView.animate(withDuration: 0.8, delay: 0.0 , options: [.curveLinear], animations: {
                    self.timeBarView.frame = CGRect(x: self.timeBarView.frame.minX, y:  self.timeBarView.frame.minY, width: finishWidth, height: self.timeBarView.frame.size.height)
            },
            completion: nil
        )
    }
    
    
}
