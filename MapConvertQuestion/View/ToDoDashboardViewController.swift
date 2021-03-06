//
//  ToDoDashboardViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/12.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import RealmSwift
import Instructions

class ToDoDashboardViewController: UIViewController {

    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var quotqLabel: UILabel!
    @IBOutlet weak var doneAmountLabel: UILabel!
    
    
    @IBOutlet weak var studyTabBar: UITabBarItem!
    @IBOutlet weak var dummyStackView: UIStackView!
    @IBOutlet weak var dummySecondTabBarItem: UIView!
    
    private let coachMarksController = CoachMarksController()
    private var pointOfInterest:UIView!
    
    var presenter:ToDoDashboardPresenter!
    var todayDoneAmount:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
        
        self.pointOfInterest = self.dummySecondTabBarItem
        self.coachMarksController.dataSource = self
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
        super.viewDidAppear(animated)
        
        self.showTutorialIfNeeded()
        self.presenter.updateUserQuota()
        UIView.animate(withDuration: 1.0) {
            var todayQuota:CGFloat = 1
            if self.presenter.todayQuota > 0 {
                todayQuota = CGFloat(self.presenter.todayQuota)
            }
            let wariai:CGFloat = (self.presenter.todayDoneAmount) / todayQuota
            self.progressView.value = CGFloat( wariai * 100)
        }
        self.quotqLabel.text = "todayQuotaIs".localized +  String(Int(self.presenter.todayQuota)) + " " +  "quizzes".localized
        self.doneAmountLabel.text = String(Int(self.presenter.todayDoneAmount)) + " / " + String(Int(self.presenter.todayQuota)) + " " + "quiz".localized + " finish!"
        self.setTabbarItemBadge()
    }
    
    private func setTabbarItemBadge(){
        if ( Int(self.presenter.todayQuota) -  Int(self.presenter.todayDoneAmount) ) > 0 {
            studyTabBar.badgeValue = String(Int(self.presenter.todayQuota) -  Int(self.presenter.todayDoneAmount))
            return
        }
        studyTabBar.badgeValue = nil
    }
    
    private func showTutorialIfNeeded(){
        print("showTutorialIfNeeded\n\n\n")
        
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["TopPageFirstLaunch" : true])
        defaults.register(defaults: ["isFirstCoachMarkInToDoDashPage" : true])
        if defaults.bool(forKey: "TopPageFirstLaunch") == true {
            self.prsentTutorialPage()
            return
        }
        print("\n\n")
        if defaults.bool(forKey: "isFirstCoachMarkInToDoDashPage") == true && defaults.bool(forKey: "TopPageFirstLaunch") == false {
            self.coachMarksController.start(in: .currentWindow(of: self))
            UserDefaults.standard.set(false, forKey: "isFirstCoachMarkInToDoDashPage")
        }
        
    }

    private func prsentTutorialPage(){
        let markDownInputModel = MarkDownInputModel()
        markDownInputModel.submitInput(input:"tutorialTextViewContent".localized)
        let new_uuid = NSUUID().uuidString
        UserDefaults.standard.set(new_uuid, forKey: "uuid")
        self.createUserData(uuid:new_uuid)
        let howToVC = R.storyboard.tutorialExplanation.howToPage()
        howToVC?.modalPresentationStyle = .fullScreen
        self.present(howToVC!, animated: true, completion: {
            UserDefaults.standard.set(false, forKey: "TopPageFirstLaunch")
        })
    }

    private func createUserData(uuid:String){
        do {
            let realm = try Realm()
            let user = User(value: ["uuid": uuid])
            try! realm.write {
                realm.add(user)
            }
        } catch {
            print("\(error)")
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

extension ToDoDashboardViewController:CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                                  coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: pointOfInterest)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = "todoDashTabCoachMark".localized
        coachViews.bodyView.nextLabel.text = "OK"
        coachViews.bodyView.nextLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
