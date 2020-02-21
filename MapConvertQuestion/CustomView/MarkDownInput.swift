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
    @IBOutlet weak var submitButton: UIButton!
    var myDelegate:MarkDownInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let customView = MarkDownInput(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        //これが表示される
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
        self.inputTextView.delegate = self
    }
    
    @IBAction func submitAction(_ sender: Any) {
        self.myDelegate?.submitAction(text: inputTextView.text!)
    }
    
}

extension MarkDownInput:UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView){
        print("did end editing")
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
        return true
    }
}
