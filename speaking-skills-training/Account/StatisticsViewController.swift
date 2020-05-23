//
//  StatisticsViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 24.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {
    @IBOutlet weak var progressSpeakingRateLabel: UILabel!
    @IBOutlet weak var progressSpeakingRateView: LineChartView!
    
    @IBOutlet weak var pronunciationProgressLabel: UILabel!
    @IBOutlet weak var pronunciationProgressView: LineChartView!
    
    let attempts = ["13.04", "17.04", "28.04", "29.04", "2.05", "6.05"]
    
    let speakingRate = [123.4, 115, 137.5, 143.4, 149, 150.4]
    let speakingRateTarget = [135, 135, 135, 135, 135, 135]
    
    let pronunciation = [89, 90, 76, 54, 69, 80]
    let pronunciationTarget = [85, 85, 85, 85, 85, 85]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        customizeChartSpeakingRate(target: speakingRateTarget, dataPoints: attempts, values: speakingRate.map{ Double($0) })
        customizeChartPronunciation(target: pronunciationTarget, dataPoints: attempts, values: pronunciation.map{ Double($0) })
    }
    
    func customizeChartSpeakingRate(target: [Int], dataPoints: [String], values: [Double]) {
        // Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        var dataEntriesTarget: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(target[i]))
            dataEntriesTarget.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Speaking rate score")
        lineChartDataSet.colors = [#colorLiteral(red: 0.475497067, green: 0.03306347877, blue: 0.4573745728, alpha: 1)]
        lineChartDataSet.circleColors = [#colorLiteral(red: 0.475497067, green: 0.03306347877, blue: 0.4573745728, alpha: 1)]
        lineChartDataSet.circleHoleColor = #colorLiteral(red: 0.9037085176, green: 0.7315570712, blue: 0.7498766184, alpha: 1)
        lineChartDataSet.circleRadius = 4
        lineChartDataSet.circleHoleRadius = 2
        lineChartDataSet.highlightColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let lineChartDataSetTarget = LineChartDataSet(entries: dataEntriesTarget, label: "Target speaking rate")
        lineChartDataSetTarget.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)]
        lineChartDataSetTarget.drawValuesEnabled = false
        lineChartDataSetTarget.drawCirclesEnabled = false
        
        let lineChartData = LineChartData(dataSets: [lineChartDataSet, lineChartDataSetTarget])
        
        progressSpeakingRateView.data = lineChartData
    }
    
    func customizeChartPronunciation(target: [Int], dataPoints: [String], values: [Double]) {
        // Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        var dataEntriesTarget: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(target[i]))
            dataEntriesTarget.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Pronunciation score")
        lineChartDataSet.colors = [#colorLiteral(red: 0.475497067, green: 0.03306347877, blue: 0.4573745728, alpha: 1)]
        lineChartDataSet.circleColors = [#colorLiteral(red: 0.475497067, green: 0.03306347877, blue: 0.4573745728, alpha: 1)]
        lineChartDataSet.circleHoleColor = #colorLiteral(red: 0.9037085176, green: 0.7315570712, blue: 0.7498766184, alpha: 1)
        lineChartDataSet.circleRadius = 4
        lineChartDataSet.circleHoleRadius = 2
        lineChartDataSet.highlightColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let lineChartDataSetTarget = LineChartDataSet(entries: dataEntriesTarget, label: "Target pronunciation")
        lineChartDataSetTarget.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)]
        lineChartDataSetTarget.drawValuesEnabled = false
        lineChartDataSetTarget.drawCirclesEnabled = false
        
        let lineChartData = LineChartData(dataSets: [lineChartDataSet, lineChartDataSetTarget])
        
        pronunciationProgressView.data = lineChartData
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
