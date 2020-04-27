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
    var dataSource:[Dictionary<String,String>] = [
        ["test":"test"],
        ["test":"test"],
        ["test":"test"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()

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
        cell.contentLabel.text = self.dataSource[indexPath.row]["test"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}



