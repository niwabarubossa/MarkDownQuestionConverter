//
//  SelectedMapAllQuestionViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/27.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class SelectedMapAllQuestionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let mindNodeShared = RealmMindNodeAccessor.sharedInstance
    var quizDataSource = [RealmMindNodeModel]()
    var tableViewDataSource = [Dictionary<String,Any>]()
    var answerNodeArray = [RealmMindNodeModel]()
    var mapID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.getMapGroupQuestion()
    }
    
    private func getMapGroupQuestion(){
        self.quizDataSource = mindNodeShared.getNodeByMapIdGroup(mapId: self.mapID)
        self.answerNodeArray = mindNodeShared.getMapGroupAnswer(mapId:self.mapID)
        for node in quizDataSource {
            let data = [
                "content": "Q." + node.content.replacingOccurrences(of:"\t", with:""),
                "isAlreadAnswerGet":false
                ] as [String : Any]
            self.tableViewDataSource.append(data)
        }
        self.tableView.reloadData()
    }

}

extension SelectedMapAllQuestionViewController: UITableViewDataSource,UITableViewDelegate {
    
    private func tableViewSetup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(QuestionAndAnswerTableViewCell.createXib(), forCellReuseIdentifier: QuestionAndAnswerTableViewCell.className)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionAndAnswerTableViewCell.className, for: indexPath ) as! QuestionAndAnswerTableViewCell
        cell.contentLabel.text = self.tableViewDataSource[indexPath.row]["content"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedNode = self.quizDataSource[indexPath.row]
        let parentNodePrimaryKey = tappedNode.nodePrimaryKey
        let answerNodeContent =  self.answerNodeArray.filter({ $0.parentNodePrimaryKey == parentNodePrimaryKey })
        if self.tableViewDataSource[indexPath.row]["isAlreadAnswerGet"] as! Bool == false {
            self.tableViewDataSource[indexPath.row]["isAlreadAnswerGet"] = true
            for answerNodeContent in answerNodeContent {
                self.tableViewDataSource[indexPath.row]["content"] = (self.tableViewDataSource[indexPath.row]["content"] as! String ) + "\n" + "A." + answerNodeContent.content.replacingOccurrences(of:"\t", with:"")
            }
        }
        self.tableView.reloadRows(at: [indexPath], with: .bottom)
    }
    
}



