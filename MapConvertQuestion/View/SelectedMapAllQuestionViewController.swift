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
    var dataSource = [RealmMindNodeModel]()
    var mapID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.getMapGroupQuestion()
    }
    
    private func getMapGroupQuestion(){
        let questionNodeArray = mindNodeShared.getNodeByMapIdGroup(mapId: self.mapID)
        for question in questionNodeArray {
            self.dataSource.append(question)
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
        cell.selectionStyle = .none
        cell.contentLabel.text = self.dataSource[indexPath.row].content.replacingOccurrences(of:"\t", with:"")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedNode = self.dataSource[indexPath.row]
        for childNodeId in tappedNode.childNodeIdArray {
            let answerNode = mindNodeShared.searchByPrimaryKey(node: <#T##RealmMindNodeModel#>)
            self.dataSource[indexPath.row].content += "\n" + answerNode.content.replacingOccurrences(of:"\t", with:"")
        }
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}



