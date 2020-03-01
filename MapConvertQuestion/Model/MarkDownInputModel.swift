//
//  MarkDownInputModel.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/20.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import RealmSwift

protocol MarkDownInputModelDelegate: class {
    func didSubmitInput()
}

class MarkDownInputModel {
    weak var delegate: MarkDownInputModelDelegate?
    var inputLineArray = [String]()
    var doneNum = [Int]()
    //インプットされたマークダウンがmindNodeに変換されている
    var mindNodeArray = [MindNode]()
    
    func submitInput(input:String){
        //realm処理
        let mapId = NSUUID().uuidString
        convertInputToLines(input:input)
        convertStringLinesToMindNode(myNodeId: 0, myIndent: 0, parentNodeId: 0)
        let realmDataArray = convertMindNodeToRealmDictionary(mindNodeArray: mindNodeArray,mapId: mapId)
        saveToRealm(realmDataArray: realmDataArray,mapId: mapId)
        self.delegate?.didSubmitInput()
        initData()
    }
    
    private func initData(){
        self.inputLineArray.removeAll()
        self.doneNum.removeAll()
        self.mindNodeArray.removeAll()
    }
    
    private func convertInputToLines(input:String){
        self.inputLineArray = input.components(separatedBy: "\n")
    }
        
    private func convertStringLinesToMindNode(myNodeId:Int,myIndent:Int,parentNodeId:Int){
        var childNodeIdArray = [Int]()
        for i in (myNodeId + 1)..<inputLineArray.count{
            if ( !doneNum.contains(i) ){
                if( myIndent >= getIndent(str: inputLineArray[i]) ){
                    doneNum.append(myNodeId)
                    let myNode = MindNode(myNodeId: myNodeId, content: inputLineArray[myNodeId], parentNodeId: parentNodeId, childNodeIdArray: childNodeIdArray)
                    mindNodeArray.append(myNode)
                    return
                }
                convertStringLinesToMindNode(myNodeId: i, myIndent: getIndent(str: inputLineArray[i]), parentNodeId: myNodeId)
                childNodeIdArray.append(i)
            }
        }
    }
    
    private func getIndent(str:String) -> Int{
        let word = "\t"
        var count = 0
        var nextRange = str.startIndex..<str.endIndex
        while let range = str.range(of: word, options: .caseInsensitive, range: nextRange) {
            count += 1
            nextRange = range.upperBound..<str.endIndex
        }
        return count
    }
    
    private func convertMindNodeToRealmDictionary(mindNodeArray: [MindNode],mapId: String) -> [[String: Any]] {
        var dictionaryArray = [[String: Any]]()
        for mindNode in mindNodeArray {
            let dictionary: [String: Any] = [
                "mapId": mapId,
                "content": mindNode.content,
                "myNodeId": mindNode.myNodeId,
                "parentNodeId": mindNode.parentNodeId,
                "childNodeIdArray":getChildNodeIdArray(mindNode: mindNode)
            ]
            dictionaryArray.append(dictionary)
        }
        return dictionaryArray
    }
    
    private func getChildNodeIdArray(mindNode: MindNode) -> [Dictionary<String,Int>]{
        var childNodeIdArray = [Dictionary<String,Int>]()
        for childNodeId in mindNode.childNodeIdArray {
            let childNodeIdInt: Int = childNodeId
            childNodeIdArray.append(["MindNodeChildId":childNodeIdInt])
        }
        return childNodeIdArray
    }

    private func saveToRealm(realmDataArray: [[String: Any]],mapId: String){
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            let mapGroup = MapGroup()
            mapGroup.mapId = mapId
            for item in realmDataArray.enumerated() {
                let node = RealmMindNodeModel(value: item.element)
                mapGroup.realmMindNodeModel.append(node)
            }
            try! realm.write {
                realm.add(mapGroup)
                print("成功だよ", mapGroup)
            }
        } catch {
            print("\(error)")
            print("エラーだよ")
        }
    }
}
