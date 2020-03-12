//
//  QuestionMapSelectPageTableViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/29.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionMapSelectPageTableViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [Dictionary<String,String>]()
    var didSelectRowAt:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshReload()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SelectQuestionMapPageTableViewCell.createXib(), forCellReuseIdentifier: SelectQuestionMapPageTableViewCell.className)
        self.dataSource = getMapTitleData()
//        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
        self.tableView.reloadData()
    }
    
    private func setRefreshReload(){
        let refreshCtl = UIRefreshControl()
        self.tableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.questionMapSelectPageTableViewController.goToQuestionPage.identifier {
            let nextVC = segue.destination as! QuestionPageViewController
            nextVC.questionMapId = self.dataSource[didSelectRowAt]["mapId"] ?? "error"
            print("\(self.dataSource[didSelectRowAt]["mapId"] ?? "error")")
        }
    }

}


extension QuestionMapSelectPageTableViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRowAt = indexPath.row
        self.performSegue(withIdentifier: R.segue.questionMapSelectPageTableViewController.goToQuestionPage, sender: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectQuestionMapPageTableViewCell.className, for: indexPath ) as! SelectQuestionMapPageTableViewCell
            cell.mapTitleLabel.text = self.dataSource[indexPath.row]["mapFirstNodeContent"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.deleteMapData(cellData: self.dataSource[indexPath.row])
            self.dataSource.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    private func deleteMapData(cellData:[String:String]){
        let realm = try! Realm()
        var mapData = MapGroup()
        if let data = realm.objects(MapGroup.self).filter("mapId = %@",cellData["mapId"]).first {
            mapData = data
        }
        let allNodeList = realm.objects(RealmMindNodeModel.self).filter("mapId = %@",cellData["mapId"])
        do{
            let realm = try Realm()
            try! realm.write {
                for node in allNodeList {
                    realm.delete(node.childNodeIdArray)
                }
                realm.delete(allNodeList)
                realm.delete(mapData)
            }
        }catch{
            print("\(error)")
        }
        self.tableView.reloadData()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.dataSource = getMapTitleData()
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
}
