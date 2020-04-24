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
    
    var expDelta:Int64 = 0 //代入される
    var howManyLevelUp = 0 //代入される
    private var updatedUserLevel = 68 //代入される
    private var beforeLevel = 30 // user.level - howManyLevelUp
    private var user:User = RealmUserAccessor.sharedInstance.getUserData()

    
    @IBOutlet weak var timeBarBaseView: UIView!
    var timeBarView = UIView()
    private var timeBarViewWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        
        //FIXME accessor直接操作は良くない
        
        super.viewDidLoad()
        timeBarView.frame = CGRect(x: 0, y: 0, width: 0, height: timeBarBaseView.frame.size.height)
        timeBarView.backgroundColor = UIColor.blue
        timeBarViewWidth = self.timeBarView.frame.size.width
        timeBarBaseView.addSubview(self.timeBarView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        timeBarViewWidth = 0.69 //とか
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let endPercent:CGFloat = CGFloat( (getNeedExpAmount(level: user.level + 1) - user.totalCharactersAmount) / getNeedExpAmount(level: user.level + 1) )
        if howManyLevelUp > 1 {
            var totalTime = 0
            for i in 1..<howManyLevelUp {
                totalTime += i
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) ) {
                    self.levelUpUI(count:i)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalTime) ) {
                self.progressAnimationFromTo(start: 0, end: endPercent)
            }
        }else if howManyLevelUp == 1 {
            self.levelUpUI(count:1)
            self.progressAnimationFromTo(start: 0, end: endPercent)
        }else{
            let startPercent:CGFloat = CGFloat( (getNeedExpAmount(level: user.level + 1) - self.expDelta) / getNeedExpAmount(level: user.level + 1) )
            self.progressAnimationFromTo(start: startPercent, end: endPercent)
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

extension UserStatusViewController{
    func getLevel(exp:Int64) -> Int{
      var level:Int = 0
      var totalExp:Int64 = exp
      while totalExp > 30 {
        totalExp = totalExp / Int64(1.1)
        level += 1
      }
      return level
    }

    func getNeedExpAmount(level:Int64) -> Int64{
      var nextExpAmount:Int64 = 30
      for _ in 1..<level {
        nextExpAmount = nextExpAmount * Int64(1.1)
      }
      return nextExpAmount
    }
    
    private func convertExpToPercent(nextLevel:Int64) -> Double{
        let necessaryExp = getNeedExpAmount(level:nextLevel) - getNeedExpAmount(level:nextLevel - 1)
        let progressPercent:Double = Double(self.user.totalCharactersAmount - getNeedExpAmount(level:nextLevel - 1) / necessaryExp)
        return progressPercent
    }
    
    private func progressAnimationFromTo(start:CGFloat,end:CGFloat){
        let baseView = self.timeBarBaseView
        let finishWidth =  end * (baseView?.frame.width ?? 0)
        UIView.animate(withDuration: 0.8, delay: 0.0 , options: [.curveLinear], animations: {
                    self.timeBarView.frame = CGRect(x: self.timeBarView.frame.minX, y:  self.timeBarView.frame.minY, width: finishWidth, height: self.timeBarView.frame.size.height)
            },
            completion: nil
        )
    }
}
