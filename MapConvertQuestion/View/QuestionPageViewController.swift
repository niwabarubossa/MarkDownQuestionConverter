//
//  QuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class QuestionPageViewController: UIViewController {
    
    var questionAnswerTableView = UITableView()
    
    var presenter:QuestionPagePresenter!
    var customView = QuestionDidsplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    //TODO これもっときれいなやり方あるはず
    var buttonStackView = ButtonStackView()
    var questionMapId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        tableViewSetup()
        layout()
        getQuestion(mapId:self.questionMapId)
    }
    
    private func initializePresenter() {
       presenter = QuestionPagePresenter(view: self)
    }
    
    private func layout(){
        customView.center = self.view.center
        customView.delegate = self
        self.view.addSubview(customView)
        let myWidth = view.frame.width
        let myHeight = view.frame.height
        buttonStackView = ButtonStackView(frame: CGRect(x: 0, y: myHeight - 180 , width: myWidth, height: 80))
        buttonStackView.delegate = self
        self.view.addSubview(buttonStackView)
    }
    
    private func getQuestion(mapId:String){
        presenter.getQuestionFromModel(mapId:mapId)
    }
    
    private func tableViewSetup(){
        questionAnswerTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: 500))
        questionAnswerTableView.center = view.center
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
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipedAction = UIContextualAction(
            style: .normal,
            title: "間違えた",
            handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                print("間違えました")
                self.presenter.wrongAnswer(row: indexPath.row)
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
                self.presenter.correctAnswer(row: indexPath.row)
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
            return true
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
