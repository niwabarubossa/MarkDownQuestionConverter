//
//  MyPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/25.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
//viewcontroller(view)-----  -------------------------

import UIKit
import Charts

class MyPageViewController: UIViewController {

    var presenter:MyPagePresenter!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var totalAnswerTimesLabel: UILabel!
    @IBOutlet weak var howToLabel: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
        initializePage()
    }
    
    private func layout(){
        let font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight(300))
        totalAnswerTimesLabel.font = font
        self.howToLabel.addGestureRecognizer((UITapGestureRecognizer(target: self, action: Selector(("howToLabelTapped:")))))
    }
    
    private func initializePage(){
        presenter.getWeeklyQuestionLog()
    }

    
    private func initializePresenter() {
       presenter = MyPagePresenter(view: self)
    }

    //presenter ← view
    func notifyToPresenter(){
        presenter.presenterFunc()
    }

    @objc private func howToLabelTapped(_ sender:UIButton){
        let howToVC = R.storyboard.settings.howToPage()
        self.present(howToVC!, animated: true, completion: nil)
    }
    
    //presenter → view
    func viewFunc(){
        print("done from presenter function")
    }

}

protocol MVPViewProtocol {
    func reloadView() -> Void
}

extension MyPageViewController:MVPViewProtocol{
    func reloadView(){
        print("get from presenter")
    }
}

//------viewcontroller(view)------------------------------
