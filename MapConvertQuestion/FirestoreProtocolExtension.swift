//
//  ProtocolExtension.swift
//  cbt_diary
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RealmSwift

protocol UpdateFirestoreDocProtocol {
    func updateFirestoreDocument(ref_array:[DocumentReference],update_data:[String:Any])
}

extension UpdateFirestoreDocProtocol {
    func updateFirestoreDocument(ref_array:[DocumentReference],update_data:[String:Any]) {
        let db = Firestore.firestore()
        let batch = db.batch()
        for ref in ref_array {
            batch.updateData(update_data, forDocument: ref)
        }
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
}

protocol SubmitFirestoreDocProtocol {
    func submitFirestoreDocument(ref_array:[DocumentReference],submit_data:[String:Any])
}

extension SubmitFirestoreDocProtocol {
    func submitFirestoreDocument(ref_array:[DocumentReference],submit_data:[String:Any]) {
        let db = Firestore.firestore()
        let batch = db.batch()
        for ref in ref_array{
            batch.setData(submit_data, forDocument: ref)
        }
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
}

protocol RealmCreateProtocol {
    func createRealm(data:Object)
}

extension RealmCreateProtocol {
    func createRealm(data:Object){
        do{
            let realm = try Realm()
            try! realm.write {
                realm.add(data)
            }
        }catch{
            print("\(error)")
        }
    }
}

protocol RealmNodeJudgeProtocol {
    func todayQuestion(nextDate:Int64)->Bool
}
extension RealmNodeJudgeProtocol {
    func todayQuestion(nextDate:Int64)->Bool{
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let todayEnd = Calendar.current.startOfDay(for: tomorrow!).millisecondsSince1970 - 1
        if nextDate >= 0 && nextDate <= todayEnd {
             return true
         }
        return false
    }
}
