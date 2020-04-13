//
//  ButtonStackView.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/09.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class ButtonStackView: UIView {

    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var abandonButton: UIButton!
    @IBOutlet weak var nextQuestionButton: UIButton!
    weak var delegate: ButtonStackViewDelegate?
    
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
        
    }
    
    @IBAction func answerButtonTapped(_ sender: Any) {
        self.delegate?.answerButtonTapped()
    }
    
    @IBAction func nextQuestionButtonTapped(_ sender: Any) {
        self.delegate?.nextQuestionButtonTapped()
    }
    
    @IBAction func abandonQuestionButtonTapped(_ sender: Any) {
        self.delegate?.abandonQuestionButtonTapped()
    }
    
}

protocol ButtonStackViewDelegate:class{
    func answerButtonTapped()
    func nextQuestionButtonTapped()
    func abandonQuestionButtonTapped()
}
