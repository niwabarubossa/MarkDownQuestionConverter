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
    var user:User = User()
    
    //オリジナルのクラス型にすること
    weak var view:ToDoDashboardViewController?

    init(view: ToDoDashboardViewController) {
        self.view = view
        self.model = ToDoDashboardModel()
        model.delegate = self
        model.addObserver(self, selector: #selector(self.getNotifyFromModel))
    }
    
//意味段落-----------------------
    func initViewController(){
        model.initViewController()
    }
    
    func didInitViewController(){
        if self.isTodayFirstLogin(user:self.user) == true {
            self.updateUserQuota()
        }
        self.view?.didInitViewController(user:self.user)
    }
//意味段落-----------------------
    
    func didGetUserData(user:User){
        self.setUser(user: user)
        //user check
    }
    
    private func updateUserQuota(){
        model.updateUserQuota(user: self.user)
    }
    
    private func isTodayFirstLogin(user:User) -> Bool{
        if LetGroup.todayStartMili > user.lastLogin {
            return true
        }
        return false
    }
    
    func setUser(user:User){
        self.user = user
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
        self.setUser(user: self.user)
        //reload view..?
    }
}

//------presenter---------------------------------------------
