//
//  ToDoDashboardViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/12.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ToDoDashboardViewController: UIViewController {

    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var quotqLabel: UILabel!
    
    var presenter:ToDoDashboardPresenter!
    var todayDoneAmount:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
//        presenter.initViewController()
    }
    
    private func initializePresenter() {
       presenter = ToDoDashboardPresenter(view: self)
    }
    
    private func layout(){
        self.startButton.layer.borderColor = UIColor.cyan.cgColor
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.cornerRadius = 5
        let font = UIFont.systemFont(ofSize: 30)
        self.startButton.titleLabel?.font = font
        startButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        progressView.value = 0
        progressView.maxValue = 100
        self.quotqLabel.text = "todayQuotaIs".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0) {
            self.progressView.value = CGFloat( (self.presenter.todayDoneAmount / self.presenter.todayQuota ) * 100)
        }
        self.quotqLabel.text = "todayQuotaIs".localized +  String(Int(self.presenter.todayQuota)) + " " +  "quizzes".localized
    }
    
    //presenter ← view
    func notifyToPresenter(){
        presenter.presenterFunc()
    }
    
    //presenter → view
    func viewFunc(){
        print("done from presenter function")
    }

}

extension ToDoDashboardViewController:MVPViewProtocol{
    func reloadView(){
        print("get from presenter")
    }
}


