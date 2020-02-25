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
    var mindNodeGroup = [MindNode]()
    
    func submitInput(input:String){
        print("submit input")
        //realm処理
        convertInputToLines(input:input)
        convertStringLinesToMindNode(myNodeId: 0, myIndent: 0, parentNodeId: 0)
        var realmMindNodeArray = [MindNode]()
        for mindNode in mindNodeGroup {
            let fitToRealmData = convertMindNodeDataToRealmData(mindNode: mindNode)
            realmMindNodeArray.append(fitToRealmData)
        }
//        saveToRealm(data: fitToRealmData)
        self.delegate?.didSubmitInput()
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
                    mindNodeGroup.append(myNode)
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
    
    private func convertMindNodeDataToRealmData(mindNode:MindNode) -> Any{
        var realmConvertedData:Any = mindNode
        var mindNodeChildIdArray = List<MindNodeChildId>()
        let childNodeIdArray = mindNode.childNodeIdArray
        for childNodeId in childNodeIdArray {
            mindNodeChildIdArray.append(MindNodeChildId(value: childNodeId))
        }
//        realmConvertedData.childNodeIdArray = mindNodeChildIdArray
        return realmConvertedData
    }
    
    private func createChildNodeIdArray(childNodeIdArray:[Int]) -> [[Int:Int]] {
        var childNodeIdArrayldRealm = [[Int:Int]]()
        for (nodeId,index) in childNodeIdArray.enumerated() {
            childNodeIdArrayldRealm.append([index:nodeId])
        }
        return childNodeIdArrayldRealm
    }

    private func saveToRealm(data: [[String: Any]]){
        do {
            let realm = try Realm()
            try! realm.write {
                realm.add(data)
            }
        } catch {
            print("\(error)")
        }
    }
}
