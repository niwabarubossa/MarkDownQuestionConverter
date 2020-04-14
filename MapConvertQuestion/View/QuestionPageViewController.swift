//
//  QuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import GoogleMobileAds

class QuestionPageViewController: UIViewController {
    
    var bannerView: GADBannerView!
    
    var presenter:QuestionPagePresenter!
    @IBOutlet weak var questionAnswerTableView: UITableView!
    @IBOutlet weak var customView: QuestionDidsplay!
    @IBOutlet weak var buttonStackView: ButtonStackView!
    
    var questionMapId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        tableViewSetup()
        layout()
        setupAdmob()
        getQuestion(mapId:self.questionMapId)
    }
    
    private func initializePresenter() {
       presenter = QuestionPagePresenter(view: self)
    }
    
    private func layout(){
        customView.center = self.view.center
        customView.delegate = self
        buttonStackView.delegate = self
        buttonStackView.abandonButton.setTitle("", for: .normal)
        buttonStackView.abandonButton.isEnabled = false
        buttonStackView.abandonButton.alpha = 0.5
    }
    
    private func setupAdmob(){
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                addBannerViewToView(bannerView)
        #if DEBUG
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
            bannerView.adUnitID = "ca-app-pub-9417520592768746/8305374316"
        #endif
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func getQuestion(mapId:String){
        presenter.getQuestionFromModel(mapId:mapId)
    }
    
    private func tableViewSetup(){
        self.questionAnswerTableView.register(QuestionAnswerTableViewCell.createXib(), forCellReuseIdentifier: QuestionAnswerTableViewCell.className)
        self.questionAnswerTableView.delegate = self
        self.questionAnswerTableView.dataSource = self
        self.view.addSubview(questionAnswerTableView)
    }
            
    func changeDisplayToAnswer(answerNodeArray:[RealmMindNodeModel]){
        self.questionAnswerTableView.reloadData()
    }
    
}

extension QuestionPageViewController:UITableViewDataSource,UITableViewDelegate{
    //本来これはPresenterに書くべきとの２つの意見があるが、こちらの方が都合が良いのでtableViewのみ特例。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionAnswerTableViewCell.className, for: indexPath ) as! QuestionAnswerTableViewCell
        let data = presenter.answerNodeArray[indexPath.row]
        cell.questionLabel.text = data.content.replacingOccurrences(of: "\t", with: "")
        cell.backgroundColor = self.convertDateToColor(ifSuccessInterval: data.ifSuccessInterval)
        
        if data.childNodeIdArray.count > 0 {
            cell.myImageView.isHidden = false
            cell.myImageView.image = R.image.arrow()
        }else{
            cell.myImageView.isHidden = true
        }
        return cell
    }
    
    private func convertDateToColor(ifSuccessInterval:Int)->UIColor{
        switch ifSuccessInterval {
        case Interval.zero.rawValue:
            return MyColor.zeroColor
        case Interval.first.rawValue:
            return MyColor.firstColor
        case Interval.second.rawValue:
            return MyColor.secondColor
        case Interval.third.rawValue:
                return MyColor.thirdColor
        case Interval.fourth.rawValue:
                return MyColor.fourthColor
        case Interval.fifth.rawValue:
                return MyColor.fifthColor
        case Interval.sixth.rawValue:
                return MyColor.sixthColor
        default:
            return MyColor.zeroColor
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.answerNodeArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if presenter.answerNodeArray[indexPath.row].childNodeIdArray.count > 0 {
            let tappedNodeId = presenter.answerNodeArray[indexPath.row].myNodeId
            presenter.changeToSelectedAnswerQuiz(tappedNodeId: tappedNodeId)
        }else{
            print("i have no answer")
        }
        self.questionAnswerTableView.deselectRow(at: indexPath, animated: true)
        
    }

}

extension QuestionPageViewController:ButtonStackViewDelegate{
    func abandonQuestionButtonTapped() {
        presenter.abandonQuestionButtonTapped()
    }
    
    func answerButtonTapped() {
        presenter.showAnswerButtonTapped()
    }
    
    func nextQuestionButtonTapped() {
        presenter.nextButtonTapped()
    }   
}

extension QuestionPageViewController{
    func addBannerViewToView(_ bannerView: GADBannerView) {
        
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
}
