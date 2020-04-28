//
//  NotifyTimeButtonStackView.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class NotifyTimeDecideView: UIView {
    
    private var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
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
        timePicker.timeZone = TimeZone(identifier: self.localTimeZoneIdentifier)
        timePicker.minuteInterval = 1
        timePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        self.timePicker.isHidden = true
    }
    
    @objc func dateChange(){
        print("date change")
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
        var calendar = Calendar(identifier: .gregorian)
        if let timezone = TimeZone(identifier: self.localTimeZoneIdentifier){
            calendar.timeZone = timezone
        }
        let pickerDate = self.timePicker.date
        var dateComponent = DateComponents()
        dateComponent.hour = calendar.component(.hour, from: pickerDate)
        dateComponent.minute = calendar.component(.minute, from: pickerDate)
        self.delegate?.submitButtonTapped(dateComponent:dateComponent)
    }
}

protocol NotifyTimeDecideViewDelegate:class{
    func submitButtonTapped(dateComponent:DateComponents)
}

