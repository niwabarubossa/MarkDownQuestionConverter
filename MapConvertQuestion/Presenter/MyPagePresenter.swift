//
//  MyPage.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/25.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//
import Foundation
import UIKit
import Charts

protocol MVPPresenterProtocol{
    func getNotifyFromModel()
}

class MyPagePresenter:QuestionLogModelDelegate{

    let model: QuestionLogModel
    var questionLogs = [QuestionLog]()
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

    func didGetQuestionLog(questionLogs: [QuestionLog]) {
        self.setQuestionLog(questionLogs: questionLogs)
        self.initializeViewController()
    }
    
    private func setQuestionLog(questionLogs: [QuestionLog]){
        self.questionLogs = questionLogs
    }
    
    private func convertLogToBarChartData(questionLogs:[QuestionLog]) -> BarChartData{
        var rawData:[Int] = [0, 0, 0, 0, 0, 0, 0]
        for quesitonLog in questionLogs {
            let weeklyIndex = self.getIndex(questionLog:quesitonLog)
            rawData[weeklyIndex] = rawData[weeklyIndex] + 1
        }
        
        var totalMinusDelta:[Int] = [0, 0, 0, 0, 0, 0, 0]
        for i in (0...totalMinusDelta.count - 2).reversed() {
            totalMinusDelta[i] = totalMinusDelta[i+1] - rawData[i+1]
        }

        var graphData:[Int] = [0, 0, 0, 0, 0, 0, 0]
        let userTotalAnswerTimes:Int = Int(model.getUserData().totalAnswerTimes)
        for i in 0..<totalMinusDelta.count {
            graphData[i] = userTotalAnswerTimes + totalMinusDelta[i]
        }
        
        let entries = graphData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        return data
    }
    
    private func getIndex(questionLog:QuestionLog) -> Int{
        var weeklyStartTime:[Int64] = [0, 0, 0, 0, 0, 0, 0]
        for i in 0..<7 {
            let beforeNow = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            let startDay = Calendar.current.startOfDay(for: beforeNow!).millisecondsSince1970 - 1
            weeklyStartTime[6 - i] = startDay
        }
        let answeredAt = questionLog.date
        if weeklyStartTime[0] < answeredAt && answeredAt < weeklyStartTime[1]  {return 0}
        if weeklyStartTime[1] < answeredAt && answeredAt < weeklyStartTime[2]  {return 1}
        if weeklyStartTime[2] < answeredAt && answeredAt < weeklyStartTime[3]  {return 2}
        if weeklyStartTime[3] < answeredAt && answeredAt < weeklyStartTime[4]  {return 3}
        if weeklyStartTime[4] < answeredAt && answeredAt < weeklyStartTime[5]  {return 4}
        if weeklyStartTime[5] < answeredAt && answeredAt < weeklyStartTime[6]  {return 5}
        return 6
    }
    
    func initializeViewController(){
        self.setupChart()
        self.getNotifyFromModel()
    }
    
    private func setupChart(){
        let data = self.convertLogToBarChartData(questionLogs: self.questionLogs)
        self.view?.barChartView.leftAxis.drawAxisLineEnabled = false
        self.view?.barChartView.xAxis.drawGridLinesEnabled = false
        self.view?.barChartView.xAxis.drawAxisLineEnabled = false
        self.view?.barChartView.leftAxis.drawAxisLineEnabled = false
        self.view?.barChartView.data = data
    }
        
    // Presenter → Model 操作する側
    func toModelFromPresenter() {
    }

    //Presenter → View の操作  操作する側
    func toViewFromPresenter() {
        view?.viewFunc()
    }

    // prsenter ← Viewの操作     操作されるやつ
    func presenterFunc() {
    }
    
    func modelDelegateFunc(){
    }

}

extension MyPagePresenter:MVPPresenterProtocol{
    @objc func getNotifyFromModel(){
        self.view?.reloadView()
    }
}
