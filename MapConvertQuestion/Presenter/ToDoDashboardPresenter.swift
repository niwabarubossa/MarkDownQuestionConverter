//
//  ToDoDashboardPresenter.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/12.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

//------presenter---------------------------------------------
import Foundation
import UIKit

class ToDoDashboardPresenter:ToDoDashboardModelDelegate{
    //自分用のモデルの宣言
    let model: ToDoDashboardModel
    
    //オリジナルのクラス型にすること
    weak var view:ToDoDashboardViewController?

    init(view: ToDoDashboardViewController) {
        self.view = view
        self.model = ToDoDashboardModel()
        model.delegate = self
        model.addObserver(self, selector: #selector(self.getNotifyFromModel))
    }

    // Presenter → Model 操作する側
    func toModelFromPresenter() {
//        model.testfunc()
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

extension ToDoDashboardPresenter:MVPPresenterProtocol{
    @objc func getNotifyFromModel(){
        
    }
}

//------presenter---------------------------------------------
