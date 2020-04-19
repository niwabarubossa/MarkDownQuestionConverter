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
    private var questionNodeCount:Int = 0
    
    private let userShared = RealmUserAccessor.sharedInstance
    private let mindNodeShared = RealmMindNodeAccessor.sharedInstance
    //インプットされたマークダウンがmindNodeに変換されている
    var mindNodeArray = [MindNode]()
    
    func submitInput(input:String){
        let mapId = NSUUID().uuidString
        convertInputToLines(input:input)
        //FIX ME //調整用としてのappendである。
        self.inputLineArray.append("this is a tyouseiyou text because i have no tab")
        let parentNodePrimaryKey:String = NSUUID().uuidString
        convertStringLinesToMindNode(myNodeId: 0, myIndent: 0, parentNodeId: 0,parentNodePrimaryKey: parentNodePrimaryKey)
        let realmDataArray = convertMindNodeToRealmDictionary(mindNodeArray: mindNodeArray,mapId: mapId)
        
        mindNodeShared.createMindNode(realmDataArray: realmDataArray,mapId: mapId)
        
        //TODO:realm UserEntityとかを作成する
        let user = userShared.getUserData()
        self.incrementUserQuota(user:user)
        self.delegate?.didSubmitInput()
        initData()
    }
    
    private func incrementUserQuota(user:User){
        let updateKeyValueArray:[String:Any] = [
            "todayQuota": user.todayQuota + self.questionNodeCount
        ]
        userShared.updateUserData(updateKeyValueArray: updateKeyValueArray, updateUser: user)
    }

    private func initData(){
        self.inputLineArray.removeAll()
        self.doneNum.removeAll()
        self.mindNodeArray.removeAll()
        self.questionNodeCount = 0
    }
    
    private func convertInputToLines(input:String){
        self.inputLineArray = input.components(separatedBy: "\n")
    }
        
    private func convertStringLinesToMindNode(myNodeId:Int,myIndent:Int,parentNodeId:Int,parentNodePrimaryKey:String){
        var childNodeIdArray = [Int]()
        let myNodePrimaryKey = NSUUID().uuidString

        for i in (myNodeId + 1)..<inputLineArray.count{
            if ( !doneNum.contains(i) ){
                if( myIndent >= getIndent(str: inputLineArray[i]) ){
                    doneNum.append(myNodeId)
                    let myNode = MindNode(myNodeId: myNodeId, myNodePrimaryKey: myNodePrimaryKey, content: inputLineArray[myNodeId], parentNodeId: parentNodeId, childNodeIdArray: childNodeIdArray,parentNodePrimaryKey:parentNodePrimaryKey)
                    mindNodeArray.append(myNode)
                    return
                }
                convertStringLinesToMindNode(myNodeId: i, myIndent: getIndent(str: inputLineArray[i]),
                                             parentNodeId: myNodeId,parentNodePrimaryKey: myNodePrimaryKey)
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
                "nodePrimaryKey": mindNode.myNodePrimaryKey,
                "parentNodeId": mindNode.parentNodeId,
                "childNodeIdArray":getChildNodeIdArray(mindNode: mindNode),
                "parentNodePrimaryKey": mindNode.parentNodePrimaryKey
            ]
            dictionaryArray.append(dictionary)
            if getChildNodeIdArray(mindNode: mindNode).count > 0  {
                questionNodeCount += 1
            }
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
}
