//
//  ToDoQuestionDisplay.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class ToDoQuestionDisplay: UIView {

    var myDelegate:ToDoQuestionDisplayDelegate?
    @IBOutlet weak var questionLabel: UILabel!
    
    
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
    }
    
    @IBAction func answerButtonTapped(_ sender: Any) {
        myDelegate?.answerButtonTapped()
    }
    
    @IBAction func nextQuestionButtonTapped(_ sender: Any) {
        myDelegate?.nextQuestionButtonTapped()
    }
    
}
