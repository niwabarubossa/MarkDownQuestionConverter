//
//  QuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class QuestionPageViewController: UIViewController {
    
    @IBOutlet weak var questionAnswerTableView: UITableView!
    
    var dataSource = [RealmMindNodeModel]()
    var presenter:QuestionPagePresenter!
    var customView = QuestionDidsplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    var questionMapId:String = ""
    var displayingNode:RealmMindNodeModel = RealmMindNodeModel()
    var answerMindNodeArray = [RealmMindNodeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
        getQuestion(mapId:self.questionMapId)
        tableViewSetup()
    }
    
    private func initializePresenter() {
       presenter = QuestionPagePresenter(view: self)
    }
    
    private func layout(){
        customView.center = self.view.center
        customView.delegate = self
        self.view.addSubview(customView)
    }
    
    private func getQuestion(mapId:String){
        presenter.getQuestionFromModel(mapId:mapId)
    }
    
    private func tableViewSetup(){
        self.questionAnswerTableView.register(QuestionAnswerTableViewCell.createXib(), forCellReuseIdentifier: QuestionAnswerTableViewCell.className)
        self.questionAnswerTableView.delegate = self
        self.questionAnswerTableView.dataSource = self

    }
        
    func changeQuizDisplay(questionNode: RealmMindNodeModel){
        self.displayingNode = questionNode
        self.customView.questionDisplayLabel.text = questionNode.content
    }
    
    func changeQuizButtonTapped(){
        let displayingNodeId:Int = self.displayingNode.myNodeId
//        let nextIndex:Int = calculateNextIndex(num: self.answerMindNodeArray)
        if
            presenter.dataSourceIndexCheck(index: displayingNodeId + 1) {
            presenter.changeQuiz(nodeId: displayingNodeId + 1)
        }else{
            presenter.changeQuiz(nodeId: 0)
        }
    }
    
    private func calculateNextIndex(num:[RealmMindNodeModel]) -> Int{
        //answerChildNodeID の nodeIdの最大のものに+1をする
//        var maxAnswerArrayNodeId:Int = 0
        var nextIndexDelta:Int = 0
        return nextIndexDelta
    }
    
    func showAnswerButtonTapped(){
        presenter.showAnswer()
    }
    
    func changeDisplayToAnswer(answerNodeArray:[RealmMindNodeModel]){
        self.dataSource = answerNodeArray
        self.questionAnswerTableView.reloadData()
    }
    
}

extension QuestionPageViewController:UITableViewDataSource,UITableViewDelegate{
    //本来これはPresenterに書くべきとの２つの意見があるが、こちらの方が都合が良いのでtableViewのみ特例。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionAnswerTableViewCell.className, for: indexPath ) as! QuestionAnswerTableViewCell
        cell.questionLabel.text = self.dataSource[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataSource[indexPath.row].childNodeIdArray.count > 0 {
            presenter.changeToSelectedAnswerQuiz(row: indexPath.row)
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
//        swipedAction.image = UIImage(named: "something") あるいは R.swift
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
        //        swipedAction.image = UIImage(named: "something") あるいは R.swift
        return UISwipeActionsConfiguration(actions: [swipedAction])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
            return true
    }

        
    
}
