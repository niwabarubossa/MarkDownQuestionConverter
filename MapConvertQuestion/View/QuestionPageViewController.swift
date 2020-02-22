//
//  QuestionPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/22.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class QuestionPageViewController: UIViewController {

    var presenter:QuestionPagePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        // Do any additional setup after loading the view.
        layout()
    }
    
    private func layout(){
        let customView = QuestionDidsplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        customView.center = self.view.center
        customView.delegate = self
        self.view.addSubview(customView)
    }
    
    private func initializePresenter() {
       presenter = QuestionPagePresenter(view: self)
    }
    
    //presenter ← view
    func notifyToPresenter(){
        presenter.myfunc()
    }
    
    //presenter → view
    func testfunc(){
        print("done from presenter function")
    }

}
