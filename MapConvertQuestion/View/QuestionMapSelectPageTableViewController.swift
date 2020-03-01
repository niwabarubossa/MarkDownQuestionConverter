//
//  QuestionMapSelectPageTableViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/29.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class QuestionMapSelectPageTableViewController: UITableViewController {

    @IBOutlet var tableVIew: UITableView!
    var dataSource:[String] = ["first","second","third"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SelectQuestionMapPageTableViewCell.createXib(), forCellReuseIdentifier: SelectQuestionMapPageTableViewCell.className)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: R.segue.questionMapSelectPageTableViewController.goToQuestionPage, sender: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectQuestionMapPageTableViewCell.className, for: indexPath ) as! SelectQuestionMapPageTableViewCell
        return cell
    }

}
