//
//  AnswerOrWrongButton.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/14.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class AnswerOrWrongButton: UIView {
    
    weak var delegate:AnswerOrWrongButtonProtocol?
    
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
    
    @IBAction func correctButtonTapped(_ sender: Any) {
        self.delegate?.correctButtonTapped()
    }
    
    @IBAction func wrongButtonTapped(_ sender: Any) {
        self.delegate?.wrongButtonTapped()
    }
    
    @IBAction func abandonButtonTapped(_ sender: Any) {
        self.delegate?.abandonButtonTapped()
    }
    
}

protocol AnswerOrWrongButtonProtocol:class{
    func correctButtonTapped()
    func wrongButtonTapped()
    func abandonButtonTapped()
}
