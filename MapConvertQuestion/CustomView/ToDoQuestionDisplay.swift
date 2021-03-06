//
//  ToDoQuestionDisplay.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class ToDoQuestionDisplay: UIView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var mapTitleLabel: UILabel!
    @IBOutlet weak var soundButton: UIButton!
    
    weak var delegate:ToDoQuestionViewDelegate?
    
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
        layout()
    }

    private func layout(){
        questionLabel.numberOfLines = 0
        self.soundButton.setImage(R.image.soundOff(), for: .normal)
    }
    
    @IBAction func soundButtonTapped(_ sender: Any) {
        self.delegate?.soundButtonTapped()
        if self.soundButton.currentImage == R.image.soundOn(){
            self.soundButton.setImage(R.image.soundOff(), for: .normal)
            return
        }
        self.soundButton.setImage(R.image.soundOn(), for: .normal)
    }
}

protocol ToDoQuestionViewDelegate:class{
    func soundButtonTapped()
}
