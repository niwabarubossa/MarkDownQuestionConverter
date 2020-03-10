//
//  ToDoQuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import UIKit

class ToDoQuestionPageViewController: UIViewController{
    
    @IBOutlet weak var answerTableView: UITableView!
    var presenter:ToDoQuestionPresenter!
    let customView = ToDoQuestionDisplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    let noQuestionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    var displayingNode:RealmMindNodeModel = RealmMindNodeModel()
    var answerNodeArrayDataSource = [RealmMindNodeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        // Do any additional setup after loading the view.
        layout()
        initializePage()
        tableViewSetup()
    }
    
    private func layout(){
        self.answerTableView.center = self.view.center
        customView.center = self.view.center
        noQuestionLabel.text = "no question !!!!!!!!!"
        noQuestionLabel.center = self.view.center
        noQuestionLabel.isHidden = true
        noQuestionLabel.sizeToFit()
        self.view.addSubview(noQuestionLabel)
        self.view.addSubview(customView)
        let myWidth = view.frame.width
        let myHeight = view.frame.height
        let buttonStackView = ButtonStackView(frame: CGRect(x: 0, y: myHeight - 180 , width: myWidth, height: 80))
        buttonStackView.delegate = self
        self.view.addSubview(buttonStackView)
    }
    
    private func initializePage(){
        //get question func
        presenter.initializePage()
    }
    
    private func tableViewSetup(){
        self.answerTableView.register(QuestionAnswerTableViewCell.createXib(), forCellReuseIdentifier: QuestionAnswerTableViewCell.className)
        self.answerTableView.delegate = self
        self.answerTableView.dataSource = self
    }
    
    private func initializePresenter() {
       presenter = ToDoQuestionPresenter(view: self)
    }
    
    //presenter → view
    func testfunc(){
        print("done from presenter function")
    }

}

extension ToDoQuestionPageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerNodeArrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionAnswerTableViewCell.className, for: indexPath ) as! QuestionAnswerTableViewCell
        let data = self.answerNodeArrayDataSource[indexPath.row]
        cell.questionLabel.text = data.content
        cell.nextDateLabel.text = String(data.ifSuccessInterval) + "日"
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
        if self.answerNodeArrayDataSource[indexPath.row].childNodeIdArray.count > 0 {
            let tappedNode = self.answerNodeArrayDataSource[indexPath.row]
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
                    self.presenter.trailingSwipeQuestion(swipedAnswer: self.answerNodeArrayDataSource[indexPath.row])
                    tableView.reloadData()
                    completion(true)
            })
            swipedAction.backgroundColor = UIColor.red
    //        swipedAction.image = UIImage(named: "something") あるいは R.swift
            return UISwipeActionsConfiguration(actions: [swipedAction])
        }
        
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let swipedAction = UIContextualAction(
                style: .normal,
                title: "正解",
                handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
                    print("正解です")
                    self.presenter.trailingSwipeQuestion(swipedAnswer:
                        self.answerNodeArrayDataSource[indexPath.row])
                    tableView.reloadData()
                    completion(true)
            })
            swipedAction.backgroundColor = UIColor.green
            //        swipedAction.image = UIImage(named: "something") あるいは R.swift
            return UISwipeActionsConfiguration(actions: [swipedAction])
        }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        let questionDate = self.answerNodeArrayDataSource[indexPath.row].nextDate
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

protocol ToDoQuestionDisplayDelegate {
    func answerButtonTapped() -> Void
    func nextQuestionButtonTapped() -> Void
}
