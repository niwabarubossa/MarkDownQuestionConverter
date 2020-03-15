//
//  TutorialContentModel.swift
//  cbt_diary
//
//  Created by 丹羽遼吾 on 2020/02/29.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import UIKit

struct TutorialContentModel{
    var title:String
    var content:String
    var imageIcon:UIImage?
    
    init(title:String,content:String,imageIcon:UIImage){
        self.title = title
        self.content = content
        self.imageIcon = imageIcon
    }
    
    static func createModels() -> [TutorialContentModel]{
        return [
            TutorialContentModel(title: "①マインドマップをクイズに変換", content: "マインドマップのアプリから、根ノードをタップしコピーして貼り付けて変換ボタンをタップ！\n親ノードがクイズに、子ノードが答え、という暗記カードに変換します。　\n子ノードを持つノードは全てクイズ扱いとなりますが、後からクイズでないものは消去することができます。", imageIcon: R.image.pencil()!),
            TutorialContentModel(title: "②クイズを解いて定着させる", content: "Answerボタンをタップすると正解が表示されます。\n左から右にスワイプで「正解」を表します。全て「緑色」になるまで１問のクイズは出題されます。 \n毎日最適な復習タイミングで出題いたします。\nまた矢印マークのある答えをタップすることで子ノードへ進むことができます。", imageIcon: R.image.student()!),
            TutorialContentModel(title: "③一覧", content: "登録して変換したマップは全てクイズとして確認できます。\nこちらではスワイプで正解不正解は行えません。\nマップの削除も行えます。", imageIcon: R.image.books()!)
        ]
    }
}
