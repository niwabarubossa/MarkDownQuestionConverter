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
    var user:User{
        model.getUserData()
    }
    var todayQuota:CGFloat{
        return CGFloat(model.getUserData().todayQuota)
    }
    var todayDoneAmount:CGFloat{
        return CGFloat(model.getTodayLogAmount())
    }
    
    //オリジナルのクラス型にすること
    weak var view:ToDoDashboardViewController?

    init(view: ToDoDashboardViewController) {
        self.view = view
        self.model = ToDoDashboardModel()
        model.delegate = self
        model.addObserver(self, selector: #selector(self.getNotifyFromModel))
        model.registerUserQuota()
    }
    
    func updateUserQuota(){
        model.updateUserQuotaFromPresenter()
    }
//意味段落-----------------------

//意味段落-----------------------
    
    func didGetTodayLogAmount(amount:Int){
        self.view?.todayDoneAmount = CGFloat(amount)
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

}

extension ToDoDashboardPresenter:MVPPresenterProtocol{
    @objc func getNotifyFromModel(){
        //reload view..?
    }
}

//------presenter---------------------------------------------
