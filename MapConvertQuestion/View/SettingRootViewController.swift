//
//  SettingRootViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/15.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import Charts

class SettingRootViewController: UIViewController {

    @IBOutlet weak var howToLabel: UIView!
    @IBOutlet weak var howToTitleLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    private var months:[String]!
    private var unitsSold:[Double]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.howToLabel.addGestureRecognizer((UITapGestureRecognizer(target: self, action: Selector("howToLabelTapped:"))))
        self.howToTitleLabel.text = "howTo".localized
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        self.setChart(dataPoints: unitsSold)
    }
    
    
    private func setChart(dataPoints: [Double]) {
        let rawData: [Int] = [20, 50, 70, 30, 60, 90, 40]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
    }
    

    @objc private func howToLabelTapped(_ sender:UIButton){
        self.performSegue(withIdentifier: R.segue.settingRootViewController.goToHowToPage, sender: nil)
    }

}
