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
        self.myTableView.register(SimpleTableViewCell.createXib(), forCellReuseIdentifier: SimpleTableViewCell.className)
    }
}

extension MapGroupAllQuestionViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: SimpleTableViewCell.className, for: indexPath ) as! SimpleTableViewCell
        cell.selectionStyle = .none
//        cell.titleLabel.text = self.dataSource[indexPath.row]["title"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
}
