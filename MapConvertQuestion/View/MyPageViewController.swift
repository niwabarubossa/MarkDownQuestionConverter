//
//  MyPageViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/25.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
//viewcontroller(view)-----  -------------------------

import UIKit
import Charts

class MyPageViewController: UIViewController {

    var presenter:MyPagePresenter!
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePresenter()
        layout()
        self.view.backgroundColor = .green
        self.setChart()
    }
    
    private func layout(){
//        let customView = QuestionDidsplay(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
//        customView .center = self.view.center
//        customView.delegate = self
//        self.view.addSubview(customView)
    }
    
    
    private func setChart(){
        let rawData: [Int] = [20, 50, 70, 30, 60, 90, 40]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
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
