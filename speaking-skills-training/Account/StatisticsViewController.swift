//
//  StatisticsViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 24.04.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import Charts
import CoreData

class StatisticsViewController: UIViewController {
    
    var attempts: Array<Attempt> = Array()
    
    // MARK: UI properties
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    // MARK: Date properties
    
    var dates: Array<String> = Array()
    
    // MARK: Speaking rate properties
    
    @IBOutlet weak var progressSpeakingRateLabel: UILabel!
    @IBOutlet weak var progressSpeakingRateView: LineChartView!
    
    var speakingRate: Array<Double> = Array()
    var speakingRateTarget: Array<Double> = Array()
    
    // MARK: Pronunciation properties
    
    @IBOutlet weak var pronunciationProgressLabel: UILabel!
    @IBOutlet weak var pronunciationProgressView: LineChartView!
    
    var pronunciation: Array<Double> = Array()
    var pronunciationTarget: Array<Double> = Array()
    
    // MARK: Core Data properties
    
    var authToken: String?
    
    // MARK: Core Data methods
    
    func fetchAuthToken() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Token")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                authToken = (data.value(forKey: "token") as! String)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Server methods
    
    private func getRequestListOfAttempts() {
        var request = URLRequest(url: URL(string: "http://37.230.114.248/Attempt/user")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        print("request: ", request as Any)
        
        let session = URLSession(configuration: .default)
        
        let decoder = JSONDecoder()
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if responseError != nil {
                print("responseError: ", responseError.debugDescription as Any)
                return
            }
            
            print("data: ", responseData!)
            
            struct Attempts: Decodable {
                let attempts: Array<Attempt>
            }
            
            do {
                let array = try decoder.decode(Attempts.self, from: responseData!)
                
                DispatchQueue.main.async {
                    self.attempts = array.attempts
                    self.getAllResultsForDisplaying(attempts: self.attempts)
                }
            } catch {
                print("Something was wrong with getting list of topics", error)
            }
        }
        
        task.resume()
    }
    
    // MARK: Private methods
    
    private func getAllResultsForDisplaying(attempts: Array<Attempt>) {
        for item in attempts {
            let startIndex = item.startTime.index(item.startTime.startIndex, offsetBy: 5)
            let endIndex = item.startTime.index(item.startTime.startIndex, offsetBy: 10)
            
            dates.append(String(item.startTime[startIndex..<endIndex]))
            
            speakingRate.append(item.speakingRate)
            speakingRateTarget.append(135.0)
            
            pronunciation.append(item.correctness * 100)
            pronunciationTarget.append(85.0)
        }
        
        customizeChartSpeakingRate(target: speakingRateTarget, dataPoints: dates, values: speakingRate.map{ Double($0) })
        customizeChartPronunciation(target: pronunciationTarget, dataPoints: dates, values: pronunciation.map{ Double($0) })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
               
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        fetchAuthToken()
        getRequestListOfAttempts()
    }
    
    // MARK: Private function
    
    func customizeChartSpeakingRate(target: [Double], dataPoints: [String], values: [Double]) {
        
        // Set ChartDataEntry for values
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        // Set ChartDataEntry for target value
        var dataEntriesTarget: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: target[i])
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
    
    func customizeChartPronunciation(target: [Double], dataPoints: [String], values: [Double]) {
        
        // Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        // Set ChartDataEntry
        var dataEntriesTarget: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: target[i])
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
