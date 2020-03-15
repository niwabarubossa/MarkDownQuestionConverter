//
//  ToDoQuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import UIKit
import CoreLocation

class ToDoQuestionPageViewController: UIViewController{
    
    var presenter:ToDoQuestionPresenter!
    var customView = ToDoQuestionDisplay()
    @IBOutlet weak var answerTableView: UITableView!
    var noQuestionLabel = ToDoQuestionCompleteLabel()
    var userDataDisplay = UserDataDisplay()
    var buttonStackView = ButtonStackView()
    
    var locationManager: CLLocationManager!
    var latitudeNow: String = ""
    var longitudeNow: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        tableViewSetup()
        layout()
        initializePage()
        self.setupLocationManager()
    }
        
    private func layout(){
        self.answerTableView.center = self.view.center
        customView = ToDoQuestionDisplay(frame: CGRect(x: 0, y: 0 , width: view.frame.width, height: view.frame.height - 500))
        customView.center = self.view.center
        noQuestionLabel = ToDoQuestionCompleteLabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        noQuestionLabel.contentLabel.text = "no question !!!!!!!!!"
        noQuestionLabel.center = self.view.center
        noQuestionLabel.isHidden = true
        self.view.addSubview(noQuestionLabel)
        self.view.addSubview(customView)
        let myWidth = view.frame.width
        let myHeight = view.frame.height
        buttonStackView = ButtonStackView(frame: CGRect(x: 0, y: myHeight - 180 , width: myWidth, height: 80))
        buttonStackView.delegate = self
        self.view.addSubview(buttonStackView)
        userDataDisplay = UserDataDisplay(frame: CGRect(x: 0, y: 100, width: myWidth, height: 100))
        self.view.addSubview(userDataDisplay)
    }
    
    private func initializePage(){
        presenter.initializePage()
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    private func tableViewSetup(){
        answerTableView.isHidden = true
        answerTableView = UITableView(frame: CGRect(x: 0, y: 0 , width: view.frame.width, height: view.frame.height - 460))
        answerTableView.center = view.center
        self.view.addSubview(answerTableView)
        self.answerTableView.register(QuestionAnswerTableViewCell.createXib(), forCellReuseIdentifier: QuestionAnswerTableViewCell.className)
        self.answerTableView.delegate = self
        self.answerTableView.dataSource = self
    }
    
    private func initializePresenter() {
       presenter = ToDoQuestionPresenter(view: self)
    }
    
    func testfunc(){
        print("done from presenter function")
    }

}

extension ToDoQuestionPageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.answerNodeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionAnswerTableViewCell.className, for: indexPath ) as! QuestionAnswerTableViewCell
        let data = presenter.answerNodeArray[indexPath.row]
        cell.questionLabel.text = data.content.replacingOccurrences(of:"\t", with:"")
        
        let timeSince1970 = data.nextDate
        let dateVar = Date.init(timeIntervalSince1970: Double(timeSince1970) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        cell.nextDateLabel.text = dateFormatter.string(from: dateVar)
        
        if data.childNodeIdArray.count > 0 {
            cell.myImageView.isHidden = false
            cell.myImageView.image = R.image.arrow()
        }else{
            cell.myImageView.isHidden = true
        }
        if todayQuestion(nextDate: data.nextDate) == true{
            cell.backgroundColor = .orange
        }else{
            cell.backgroundColor = .green
        }
         return cell
    }
    
    private func todayQuestion(nextDate:Int64)->Bool{
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let todayEnd = Calendar.current.startOfDay(for: tomorrow!).millisecondsSince1970 - 1
        if nextDate >= 0 && nextDate <= todayEnd {
             return true
         }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if presenter.answerNodeArray[indexPath.row].childNodeIdArray.count > 0 {
            presenter.changeToQuestionMode()
            let tappedNode = presenter.answerNodeArray[indexPath.row]
            presenter.changeToSelectedAnswerQuiz(tappedNode: tappedNode)
        }else{
            print("i have no answer")
        }
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let swipedAction = UIContextualAction(
                style: .normal,
                title: "間違えた",
                handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                    print("間違えました")
                    self.presenter.trailingSwipeQuestion(swipedAnswer: self.presenter.answerNodeArray[indexPath.row])
                    tableView.reloadData()
                    completion(true)
            })
            swipedAction.backgroundColor = UIColor.red
            swipedAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
                R.image.wrong()?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
            }
            return UISwipeActionsConfiguration(actions: [swipedAction])
        }
        
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let swipedAction = UIContextualAction(
                style: .normal,
                title: "正解",
                handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                    print("正解です")
                    self.presenter.leadingSwipeQuestion(swipedAnswer:
                        self.presenter.answerNodeArray[indexPath.row])
                    tableView.reloadData()
                    completion(true)
            })
            swipedAction.backgroundColor = UIColor.green
            swipedAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
                R.image.done()?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
            }
            return UISwipeActionsConfiguration(actions: [swipedAction])
        }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        let questionDate = presenter.answerNodeArray[indexPath.row].nextDate
        if self.todayQuestion(nextDate: questionDate) == true {
            return true
        }
        //スワイプ　つまり正解にできるのは今日の問題のみ
        return false
    }
    
}

extension ToDoQuestionPageViewController:ButtonStackViewDelegate{
    func answerButtonTapped() {
        print("answerButtonTapped")
        presenter.answerButtonTapped()
    }
    
    func abandonQuestionButtonTapped() {
        print("abandonQuestionButtonTapped")
        presenter.abandonQuestionButtonTapped()
    }
    func nextQuestionButtonTapped(){
        print("nextQuestionButtonTapped")
        presenter.nextQuestionButtonTapped()
    }

}

extension ToDoQuestionPageViewController:UserDataModelViewProtocol{
    
    func reloadUserDataModelView() {
         print("reload user data model view")
    }
}

extension ToDoQuestionPageViewController:QuestionModelViewProtocol{
    
    func reloadQuestionModelView() {
        print("reload questoin model view controller")
    }
}

extension ToDoQuestionPageViewController: CLLocationManagerDelegate {
    /// 位置情報が更新された際、位置情報を格納する
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        self.latitudeNow = String(latitude!)
        self.longitudeNow = String(longitude!)
    }
}

protocol ToDoQuestionDisplayDelegate {
    func answerButtonTapped() -> Void
    func nextQuestionButtonTapped() -> Void
}


