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
    
    var dataSource = [String]()
    var presenter:QuestionPagePresenter!
    var customView = QuestionDidsplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    var questionMapId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
        getQuestion(mapId:self.questionMapId)
        self.questionAnswerTableView.register(QuestionAnswerTableViewCell.createXib(), forCellReuseIdentifier: QuestionAnswerTableViewCell.className)
        self.questionAnswerTableView.delegate = self
        self.questionAnswerTableView.dataSource = self
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
        
    func changeQuizDisplay(question: String){
        self.customView.questionDisplayLabel.text = question
    }
    
    func changeQuizButtonTapped(){
        changeToQuestionMode()
        presenter.changeQuiz()
    }
    
    func changeToQuestionMode(){
        self.customView.questionDisplayLabel.isHidden = false
        self.questionAnswerTableView.isHidden = true
    }
    
    func changeToAnswerMode(){
        self.customView.questionDisplayLabel.isHidden = true
        self.questionAnswerTableView.isHidden = false
    }
    
    func showAnswerButtonTapped(){
        changeToAnswerMode()
        presenter.showAnswer()
    }
    
    func changeDisplayToAnswer(answer_array:[String]){
        self.dataSource = answer_array
        self.questionAnswerTableView.reloadData()
    }
    
}

extension QuestionPageViewController:UITableViewDataSource,UITableViewDelegate{
    //本来これはPresenterに書くべきとの２つの意見があるが、こちらの方が都合が良いのでtableViewのみ特例。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionAnswerTableViewCell.className, for: indexPath ) as! QuestionAnswerTableViewCell
        cell.questionLabel.text = self.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        presenter.changeToSelectedAnswerQuiz(row: indexPath.row)
    }
}
