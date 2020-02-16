//
//  MarkDownInput.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/16.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class MarkDownInput: UIView {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var indentAndLineButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    
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
}
