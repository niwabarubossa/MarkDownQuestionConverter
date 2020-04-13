//
//  UserDataDisplay.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/11.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class UserDataDisplay: UIView {
    
    @IBOutlet weak var howManyTimesAnswered: UILabel!
    
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var finishTitleLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var answerTimesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var bunboLabel: UILabel!
    @IBOutlet weak var bunsiLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
        self.image.image = R.image.student()
        self.howManyTimesAnswered.text = "howManyTimesAnswered".localized
        self.scoreTitleLabel.text = "score".localized
        self.finishTitleLabel.text = "finish".localized
        self.progressView.transform = progressView.transform.scaledBy(x: 1, y: 3)
        self.progressView.progressTintColor = MyColor.progressTintColor
        temp()
    }
    
    private func temp(){
        bunboLabel.isHidden = true
        bunsiLabel.isHidden = true
        finishTitleLabel.isHidden = true
    }
}
