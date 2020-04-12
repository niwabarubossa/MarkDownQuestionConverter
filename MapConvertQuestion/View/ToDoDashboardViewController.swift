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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        progressView.value = 0
        progressView.maxValue = 30
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 1.0) {
            self.progressView.value = 15
        }
    }
    
    private func layout(){
//        let customView = QuestionDidsplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
//        customView .center = self.view.center
//        customView.delegate = self
//        self.view.addSubview(customView)
    }
    
    private func initializePresenter() {
       presenter = ToDoDashboardPresenter(view: self)
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


