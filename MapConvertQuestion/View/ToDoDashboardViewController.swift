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
    
    var presenter:ToDoDashboardPresenter!
    var todayDoneAmount:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
        presenter.initViewController()
    }
    
    private func initializePresenter() {
       presenter = ToDoDashboardPresenter(view: self)
    }
    
    private func layout(){
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        progressView.value = todayDoneAmount
        progressView.maxValue = 0
    }
    
    func didInitViewController(user:User,amount:Int){
        UIView.animate(withDuration: 1.0) {
            self.progressView.value = CGFloat(amount)
            self.progressView.maxValue = CGFloat(user.todayQuota)
        }
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


