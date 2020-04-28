//
//  NotifyTimeButtonStackView.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class NotifyTimeDecideView: UIView {
    
    weak var delegate: NotifyTimeDecideViewDelegate?
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
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
        timePicker.locale = Locale.autoupdatingCurrent
    }
    
    private func getLocalDateTimeString(_ date:Date? = Date() )->String {
        if date == nil {return "--/--"}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat = "HH/mm"
        return dateFormatter.string(from: date!) as String
    }
    
    
    
}

protocol NotifyTimeDecideViewDelegate:class{
    func answerButtonTapped()
    func nextQuestionButtonTapped()
    func abandonQuestionButtonTapped()
}

