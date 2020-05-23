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
    
    let attempts = ["13.04", "17.04", "28.04", "29.04", "2.05", "6.05"]
    
    // MARK: Speaking rate properties
    
    @IBOutlet weak var progressSpeakingRateLabel: UILabel!
    @IBOutlet weak var progressSpeakingRateView: LineChartView!
    
    let speakingRate = [123.4, 115, 137.5, 143.4, 149, 150.4]
    let speakingRateTarget = [135, 135, 135, 135, 135, 135]
    
    // MARK: Pronunciation properties
    
    @IBOutlet weak var pronunciationProgressLabel: UILabel!
    @IBOutlet weak var pronunciationProgressView: LineChartView!
    
    let pronunciation = [89, 90, 76, 54, 69, 80]
    let pronunciationTarget = [85, 85, 85, 85, 85, 85]
    
    // Called after the controller's view is loaded into memory.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        customizeChartSpeakingRate(target: speakingRateTarget, dataPoints: attempts, values: speakingRate.map{ Double($0) })
        
        customizeChartPronunciation(target: pronunciationTarget, dataPoints: attempts, values: pronunciation.map{ Double($0) })
    }
    
    // MARK: Private function
    
    func customizeChartSpeakingRate(target: [Int], dataPoints: [String], values: [Double]) {
        
        // Set ChartDataEntry for values
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        // Set ChartDataEntry for target value
        var dataEntriesTarget: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(target[i]))
            dataEntriesTarget.append(dataEntry)
        }
        
        // Set LineChartDataSet design properties
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Speaking rate score")
        lineChartDataSet.colors = [#colorLiteral(red: 0.475497067, green: 0.03306347877, blue: 0.4573745728, alpha: 1)]
        lineChartDataSet.circleColors = [#colorLiteral(red: 0.475497067, green: 0.03306347877, blue: 0.4573745728, alpha: 1)]
        lineChartDataSet.circleHoleColor = #colorLiteral(red: 0.9037085176, green: 0.7315570712, blue: 0.7498766184, alpha: 1)
        lineChartDataSet.circleRadius = 4
        lineChartDataSet.circleHoleRadius = 2
        lineChartDataSet.highlightColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Set LineChartDataSetTarger design properties
        let lineChartDataSetTarget = LineChartDataSet(entries: dataEntriesTarget, label: "Target speaking rate")
        lineChartDataSetTarget.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)]
        lineChartDataSetTarget.drawValuesEnabled = false
        lineChartDataSetTarget.drawCirclesEnabled = false
        
        // Combine two charts
        let lineChartData = LineChartData(dataSets: [lineChartDataSet, lineChartDataSetTarget])
        
        // Set ProgressSpeakingRateView formatter
        progressSpeakingRateView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return dataPoints[Int(index)] })
        progressSpeakingRateView.xAxis.setLabelCount(dataPoints.count, force: true)
        
        // Create NumberFormatter for left axis
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .currency
        valFormatter.maximumFractionDigits = 1
        valFormatter.currencySymbol = "wpm  "
        
        // Set ValueFormatter for right and left axes
        progressSpeakingRateView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        progressSpeakingRateView.rightAxis.enabled = false
        
        // Assign LineChartData to ProgressSpeakingRateView object
        progressSpeakingRateView.data = lineChartData
    }
    
    func customizeChartPronunciation(target: [Int], dataPoints: [String], values: [Double]) {
        
        // Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        // Set ChartDataEntry
        var dataEntriesTarget: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(target[i]))
            dataEntriesTarget.append(dataEntry)
        }
        
        // Set LineChartDataSet design properties
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Pronunciation score")
        lineChartDataSet.colors = [#colorLiteral(red: 0.475497067, green: 0.03306347877, blue: 0.4573745728, alpha: 1)]
        lineChartDataSet.circleColors = [#colorLiteral(red: 0.475497067, green: 0.03306347877, blue: 0.4573745728, alpha: 1)]
        lineChartDataSet.circleHoleColor = #colorLiteral(red: 0.9037085176, green: 0.7315570712, blue: 0.7498766184, alpha: 1)
        lineChartDataSet.circleRadius = 4
        lineChartDataSet.circleHoleRadius = 2
        lineChartDataSet.highlightColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Set LineChartDataSetTarget design properties
        let lineChartDataSetTarget = LineChartDataSet(entries: dataEntriesTarget, label: "Target pronunciation")
        lineChartDataSetTarget.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)]
        lineChartDataSetTarget.drawValuesEnabled = false
        lineChartDataSetTarget.drawCirclesEnabled = false
        
        // Combine two charts
        let lineChartData = LineChartData(dataSets: [lineChartDataSet, lineChartDataSetTarget])
        
        // Set PronunciationProgressView formatter
        pronunciationProgressView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
                   return dataPoints[Int(index)] })
        pronunciationProgressView.xAxis.setLabelCount(dataPoints.count, force: true)
          
        // Create NumberFormatter for left axis
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .currency
        valFormatter.maximumFractionDigits = 2
        valFormatter.currencySymbol = "%  "
            
        // Set ValueFormatter for right and left axes
        pronunciationProgressView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        pronunciationProgressView.rightAxis.enabled = false
        
        // Assign LineChartData to PronunciationProgressView object
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
