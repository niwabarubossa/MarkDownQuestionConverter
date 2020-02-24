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
        
        print("mindNodeGroup")
        testDisplay(mindNodeGroup: mindNodeGroup)
        saveToRealm(data: "")
        self.delegate?.didSubmitInput()
    }
    
    private func testDisplay(mindNodeGroup:[MindNode]){
        for item in mindNodeGroup {
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

    private func saveToRealm(data: String){
        do {
            let realm = try Realm()
            let dictionary: [String: Any] = [
                "content": "test",
                "myNodeId": 0,
                "parentNodeId": 9,
                "childNodeIdArray":[
                    [0:0],
                    [1:1],
                    [2:2]
                ]
            ]
            let mindMapNode = RealmMindNodeModel(value: dictionary)
            try! realm.write {
                realm.add(mindMapNode)
                print("成功だよ", dictionary)
            }
        } catch {
            print("want_to_print")
            print("\(error)")
            print("エラーだよ")
        }
    }
}
