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
import Charts

protocol MVPPresenterProtocol{
    func getNotifyFromModel()
}

class MyPagePresenter:QuestionLogModelDelegate{
    //自分用のモデルの宣言
    let model: QuestionLogModel
    var questionLogs = [QuestionLog]()
    //オリジナルのクラス型にすること
    weak var view:MyPageViewController?

    init(view: MyPageViewController) {
        self.view = view
        self.model = QuestionLogModel()
        model.delegate = self
        model.addObserver(self, selector: #selector(self.getNotifyFromModel))
    }
    
    func getWeeklyQuestionLog() {
        model.getWeeklyQuestionLog()
    }

    func didGetWeeklyQuestionLog(questionLogs: [QuestionLog]) {
        self.setQuestionLog(questionLogs: questionLogs)
        self.initializeViewController()
    }
    
    private func setQuestionLog(questionLogs: [QuestionLog]){
        self.questionLogs = questionLogs
    }
    
    private func convertLogToBarChartData(questionLogs:[QuestionLog]) -> BarChartData{
        let rawData: [Int] = [20, 50, 70, 30, 60, 90, 40]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        return data
    }
    
    func initializeViewController(){
        //データ加工
        //データの流し込み
        let data = self.convertLogToBarChartData(questionLogs: self.questionLogs)
        self.view?.barChartView.data = data
        self.getNotifyFromModel()
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

extension MyPagePresenter:MVPPresenterProtocol{
    @objc func getNotifyFromModel(){
        self.view?.reloadView()
    }
}

//------presenter---------------------------------------------

