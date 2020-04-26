//
//  MapGroupAllQuestionViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/26.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class MapGroupAllQuestionViewController: UIViewController {

    let mindNodeShared = RealmMindNodeAccessor.sharedInstance
    var dataSource:[Dictionary<String,String>]{
        return mindNodeShared.getAllTitle()
    }
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewdidload内部
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.register(PlainTableViewCell.createXib(), forCellReuseIdentifier: PlainTableViewCell.className)
    }
}

extension MapGroupAllQuestionViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: PlainTableViewCell.className, for: indexPath ) as! PlainTableViewCell
        cell.selectionStyle = .none
//        cell.contentLabel.text = self.dataSource[indexPath.row]["title"]
        cell.contentLabel.text = self.dataSource[indexPath.row]["title"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
}
