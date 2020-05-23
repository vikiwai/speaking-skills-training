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
    @IBOutlet weak var pronunciationProgressView: UIView!
    
    let attempts = ["1", "2", "3", "4", "5", "6"]
    let speakingRate = [123.4, 115, 137.5, 143.4, 149, 150.4]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeChart(dataPoints: attempts, values: speakingRate.map{ Double($0) })
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
       // Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
            
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        progressSpeakingRateView.data = lineChartData
        
        
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
