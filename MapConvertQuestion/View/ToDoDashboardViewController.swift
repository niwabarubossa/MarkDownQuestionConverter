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
        self.tutorialIfFirstLaunch()
        self.presenter.updateUserQuota()
        UIView.animate(withDuration: 1.0) {
            var todayQuota:Int = 1
            print("\(self.presenter.todayQuota)")
            if self.presenter.todayQuota > 0 {
                todayQuota = Int(self.presenter.todayQuota)
            }
            
            self.progressView.value = CGFloat( ( Int(self.presenter.todayDoneAmount) / todayQuota ) * 100)
        }
        self.quotqLabel.text = "todayQuotaIs".localized +  String(Int(self.presenter.todayQuota)) + " " +  "quizzes".localized
    }
    
    private func tutorialIfFirstLaunch(){
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["TopPageFirstLaunch" : true])
        if defaults.bool(forKey: "TopPageFirstLaunch") == true {
            //create first tutorial content
            let markDownInputModel = MarkDownInputModel()
            markDownInputModel.submitInput(input:"tutorialTextViewContent".localized)
            UserDefaults.standard.set(false, forKey: "TopPageFirstLaunch")

            let new_uuid = NSUUID().uuidString
            UserDefaults.standard.set(new_uuid, forKey: "uuid")
            self.createUserData(uuid:new_uuid)
            let howToVC = R.storyboard.settings.howToPage()
            self.present(howToVC!, animated: true, completion: nil)
        }else{
            UserDefaults.standard.set(false, forKey: "TopPageFirstLaunch")
        }
    }

    private func createUserData(uuid:String){
        do {
            let realm = try Realm()
            let user = User(value: [ "uuid": uuid])
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


