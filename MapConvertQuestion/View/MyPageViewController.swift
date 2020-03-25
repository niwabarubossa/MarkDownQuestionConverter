//
//  MyPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/25.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
//viewcontroller(view)-----  -------------------------

import UIKit

class MyPageViewController: UIViewController {

    var presenter:MyPagePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
    }
    
    private func layout(){
//        let customView = QuestionDidsplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
//        customView .center = self.view.center
//        customView.delegate = self
//        self.view.addSubview(customView)
    }
    
    private func initializePresenter() {
       presenter = MyPagePresenter(view: self)
    }
    
    //presenter ← view
    func notifyToPresenter(){
        presenter.presenterFunc()
    }
    
    //presenter → view
    func viewFunc(){
        print("done from presenter function")
    }

}


protocol MVPViewProtocol {
    func reloadView() -> Void
}

extension MyPageViewController:MVPViewProtocol{
    func reloadView(){
        print("get from presenter")
    }
}


//------viewcontroller(view)------------------------------
