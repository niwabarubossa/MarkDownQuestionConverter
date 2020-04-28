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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
        initializePage()
    }
    
    private func layout(){
        totalAnswerTimesLabel.text = "totalAnswerTimesLabel".localized
        totalAnswerTimesLabel.font = UIFont(name: LetGroup.baseFontName, size: 25)
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
    
    @IBAction func howToButtonTapped(_ sender: Any) {
        let howToVC = R.storyboard.tutorialExplanation.howToPage()
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
