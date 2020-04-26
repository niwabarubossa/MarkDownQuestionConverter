//
//  MapGroupAllQuestionViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/26.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class MapGroupAllQuestionViewController: UINavigationController {

    let mindNodeShared = RealmMindNodeAccessor.sharedInstance
    var dataSource:[Dictionary<String,String>] = [
        ["test":"test"],
        ["test":"test"],
        ["test":"test"],
    ]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewdidload内部
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SimpleTableViewCell.createXib(), forCellReuseIdentifier: SimpleTableViewCell.className)
    }
}

extension MapGroupAllQuestionViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTableViewCell.className, for: indexPath ) as! SimpleTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
}
