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
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
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
        self.setupTimePicker()
    }
    
    private func setupTimePicker(){
        timePicker.locale = Locale.autoupdatingCurrent
        timePicker.timeZone = NSTimeZone.local
        timePicker.minuteInterval = 10
        timePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        self.timePicker.isHidden = true
    }
    
    @objc func dateChange(){
        print("date change")
    }

    private func getLocalDateTimeString(_ date:Date? = Date() )->String {
        if date == nil {return "--/--"}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat = "HH/mm"
        return dateFormatter.string(from: date!) as String
    }
    
    private func isRaddioButtonControl(selectedButton:UIButton){
        let btnArray = [firstButton,secondButton,thirdButton,fourthButton]
        self.timePicker.isHidden = true
        for button in btnArray {
            self.buttonInactivate(button:button!)
        }
        self.buttonActivate(button:selectedButton)
    }
    
    private func buttonInactivate(button:UIButton){
        button.alpha = 0.3
    }
    
    private func buttonActivate(button:UIButton){
        button.alpha = 1.0
    }
    
    @IBAction func firstButtonTapped(_ sender: Any) {
        self.isRaddioButtonControl(selectedButton: firstButton)
    }
    @IBAction func secondButtonTapped(_ sender: Any) {
        self.isRaddioButtonControl(selectedButton: secondButton)
    }
    @IBAction func thirdButtonTapped(_ sender: Any) {
        self.isRaddioButtonControl(selectedButton: thirdButton)
    }
    @IBAction func fourthButtonTapped(_ sender: Any) {
        self.isRaddioButtonControl(selectedButton: fourthButton)
        self.timePicker.isHidden = false
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH/mm"
        print("\(formatter.string(from: timePicker.date))")
        self.delegate?.submitButtonTapped()
    }
}

protocol NotifyTimeDecideViewDelegate:class{
    func submitButtonTapped()
}

