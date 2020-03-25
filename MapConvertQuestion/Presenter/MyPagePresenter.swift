//
//  MyPage.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/25.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

//1 storyboard作成
//2 storyboardにカスタムクラスでVCを登録
//3 customview.swift
//4 customview.xib を作成して　owner"sfileに３を登録
//5 ファイル切り分ける


//------presenter---------------------------------------------

import Foundation
import UIKit

class MyPagePresenter:QuestionLogModelDelegate{
    //自分用のモデルの宣言
    let model: QuestionLogModel
    
    //オリジナルのクラス型にすること
    weak var view:MyPageViewController?

    init(view: MyPageViewController) {
        self.view = view
        self.model = QuestionLogModel()
        model.delegate = self
    }

    // Presenter → Model 操作する側
    func toModelFromPresenter() {
        model.testfunc()
    }

    //Presenter → View の操作  操作する側
    func toViewFromPresenter() {
        view?.viewFunc()
    }

    // prsenter ← Viewの操作     操作されるやつ
    func presenterFunc() {
        print("notify from view")
    }
    
    func modelDelegateFunc(){
        print("model delegate func in presenter")
    }

}


//------presenter---------------------------------------------

