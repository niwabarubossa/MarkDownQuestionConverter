//
//  ToDoQuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/04.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import UIKit

class ToDoQuestionPageViewController: UIViewController,ToDoQuestionDisplayDelegate {

    
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
        customView.center = self.view.center
        noQuestionLabel.text = "no question !!!!!!!!!"
        noQuestionLabel.center = self.view.center
        noQuestionLabel.isHidden = true
        noQuestionLabel.sizeToFit()
        self.view.addSubview(noQuestionLabel)
        customView.myDelegate = self
        self.view.addSubview(customView)
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
    
    func answerButtonTapped() {
        print("answerButtonTapped")
        presenter.answerButtonTapped()
    }
    
    func nextQuestionButtonTapped(){
        print("nextQuestionButtonTapped")
        presenter.nextQuestionButtonTapped()
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
        print("answerNodeArrayDataSource.count")
        print("\(answerNodeArrayDataSource.count)")
        return answerNodeArrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionAnswerTableViewCell.className, for: indexPath ) as! QuestionAnswerTableViewCell
         cell.questionLabel.text = self.answerNodeArrayDataSource[indexPath.row].content
       print("cell content")
        print("\(self.answerNodeArrayDataSource[indexPath.row].content)")
         return cell
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
        return true
    }
    
}

protocol ToDoQuestionDisplayDelegate {
    func answerButtonTapped() -> Void
    func nextQuestionButtonTapped() -> Void
}
