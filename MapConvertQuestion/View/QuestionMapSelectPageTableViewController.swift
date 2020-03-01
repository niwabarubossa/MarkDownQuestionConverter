//
//  QuestionMapSelectPageTableViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/29.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionMapSelectPageTableViewController: UITableViewController {

    @IBOutlet var tableVIew: UITableView!
    var dataSource = [Dictionary<String,String>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SelectQuestionMapPageTableViewCell.createXib(), forCellReuseIdentifier: SelectQuestionMapPageTableViewCell.className)
        
        self.dataSource = getMapTitleData()
        
        self.tableView.reloadData()
    }
    
    private func getMapTitleData() -> [Dictionary<String,String>]{
        let realm = try! Realm()
        let mapIdAllData = realm.objects(MapGroup.self)
        var mapIdArray = [String]()
        for item in mapIdAllData {
            mapIdArray.append(item.mapId)
        }
        var titleDataArray = [String]()
        for mapId in mapIdArray {
            let mapFirstNodeContentResult = realm.objects(RealmMindNodeModel.self).filter("myNodeId == 0").filter("mapId == %@",mapId)
            if mapFirstNodeContentResult.count > 0 {
                titleDataArray.append(mapFirstNodeContentResult[0].content)
            }else{
                print("search result not exist")
            }
        }
        var mapAndTitleData = [Dictionary<String,String>]()

        for i in 0..<titleDataArray.count {
            let data = [
                "mapId": mapIdArray[i],
                "mapFirstNodeContent": titleDataArray[i]
            ]
            mapAndTitleData.append(data)
        }
        return mapAndTitleData
    }

}

extension QuestionMapSelectPageTableViewController {
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
            cell.mapTitleLabel.text = self.dataSource[indexPath.row]["mapFirstNodeContent"]
        return cell
    }
}
