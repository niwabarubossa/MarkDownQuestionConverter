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
        print("submit input")
        //realm処理
        convertInputToLines(input:input)
        convertStringLinesToMindNode(myNodeId: 0, myIndent: 0, parentNodeId: 0)
        print("mindNodeArray")
        testDisplay(mindNodeArray: mindNodeArray)
        let realmDataArray = convertMindNodeToRealmDictionary(mindNodeArray: mindNodeArray)
        saveToRealm(realmDataArray: realmDataArray)
        self.delegate?.didSubmitInput()
    }
    
    private func testDisplay(mindNodeArray:[MindNode]){
        for item in mindNodeArray {
            print("\(item)")
        }
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
    
    private func convertMindNodeToRealmDictionary(mindNodeArray: [MindNode]) -> [[String: Any]] {
        var dictionaryArray = [[String: Any]]()
        for mindNode in mindNodeArray.enumerated() {
            let dictionary: [String: Any] = [
                "content": "test",
                "myNodeId": 0,
                "parentNodeId": 9,
                "childNodeIdArray":getChildNodeIdArray(mindNode: mindNode)
            ]
            dictionaryArray.append(dictionary)
        }
        return dictionaryArray
    }
    
    private func getChildNodeIdArray(mindNode: MindNode) -> [[Int:Int]]{
        var childNodeIdArray = [Int:Int]()
        for childNodeId in mindNode.childNodeIdArray.enumerated() {
            childNodeIdArray.updateValue(childNodeId as! Int, forKey: "\(String(childNodeId))")
        }
        return [childNodeIdArray]
    }
    
    

    private func saveToRealm(realmDataArray: [[String: Any]]){
        do {
            let realm = try Realm()
            var saveDataArray = [RealmMindNodeModel]()
            for item in realmDataArray.enumerated() {
                saveDataArray.append( RealmMindNodeModel(value: item) )
            }
            try! realm.write {
                realm.add(saveDataArray)
                print("成功だよ", saveDataArray)
            }
        } catch {
            print("\(error)")
            print("エラーだよ")
        }
    }
}
