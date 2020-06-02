//
//  TopicViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 17.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import CoreData

class TopicViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: Structures
    
    struct ConfigurationModel {
        public let id: Int
        public let titleText: String
        public let categoryText: String
        public let levelText: String
        public let modelAnswerText: String
        public let descriptionText: String
    }
    
    // MARK: Properties
    
    var authToken: String?
    
    var id: Int! // topic id
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var rulesTextView: UITextView!
    @IBOutlet weak var modelAnswerTextView: UITextView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startRecordingButton: UIButton!
    
    var configurationModel: ConfigurationModel?
    
    // MARK: Audio properties
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var recordNumber: Int = 0
    
    var startTime: String? //
    var finishTime: String? //
    var ext: String = "m4a" //
    var recording: Array<UInt8>?
    var pronouncedText: String?
    var speakingRate: Double?
    var correctness: Double?
    var averagePause: Double?
    var shimmer: Double?
    var jitter: Double?
    var pitchVoicing: Double?
    
    // MARK: Analysis properties
    
    var recordPath: URL!
    var text: String!
    var check: [(String, Bool)] = []
    
    // MARK: Time Counter
    
    var seconds = 0
    var timer = Timer()
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TopicViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        
        if seconds >= 120 {
            timeLabel.textColor = .red
        }
        timeLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func stopTimer() {
        timer.invalidate()
        seconds = 0
        
        timeLabel.textColor = .black
        timeLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func getTime() -> String {
        let date = Date()
        
        let dateFormatterDay: DateFormatter = DateFormatter()
        dateFormatterDay.dateFormat = "yyyy-MM-dd"
        let dateFormatterTime: DateFormatter = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm:ss"
        
        let dateString = "\(dateFormatterDay.string(from: date))T\(dateFormatterTime.string(from: date)).000Z"
        
        return dateString
    }
    
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
    
    // MARK: Actions
    
    @IBAction func didTapStartRecordingButton(_ sender: Any) {
        if audioRecorder == nil {
            recordNumber += 1
            
            let filename = getDirectory().appendingPathComponent("\(recordNumber).m4a")
            recordPath = filename
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 1200, AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                self.startTime = getTime()
                
                runTimer()
                
                startRecordingButton.setTitle("Stop recording", for: .normal)
            } catch {
                displayAlert(title: "UPS!", message: "Recording failed")
            }
        } else {
            audioRecorder.stop()
            audioRecorder = nil
            
            self.finishTime = getTime()
            
            stopTimer()
            
            startRecordingButton.setTitle("Start recording", for: .normal)
            
            do {
                let data = try Data(contentsOf: recordPath)
                self.recording = Array(data)
            } catch {
                print("Generating bytes error")
            }
            
            recordingProcess(path: recordPath)
        }
    }
    
    // MARK: Private methods
    
    private func recordingProcess(path: URL) {
        SFSpeechRecognizer.requestAuthorization {
            
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                if let path = self.recordPath {
                    print("Path to request " + "\(path)")
                }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            @unknown default:
                print("Recording process error")
            }
        }
        
        self.transcribeFile(url: path, locale: Locale(identifier: "en-GB"))
    }
    
    fileprivate func transcribeFile(url: URL, locale: Locale) {
        guard let recognizer = SFSpeechRecognizer(locale: locale) else {
            print("Speech recognition not available for specified locale")
            return
        }
        
        if !recognizer.isAvailable {
            print("Speech recognition not currently available")
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        
        recognizer.recognitionTask(with: request) { (result, error) in
            if let transcription = result?.bestTranscription {
                self.text = transcription.formattedString
                print(transcription.formattedString)
                
                if result!.isFinal {
                    self.pronouncedText = self.text!
                    print(self.pronouncedText!)
                    
                    self.check = self.checkCorrectSpokenText(sourceText: self.modelAnswerTextView.text, spokenText: self.modelAnswerTextView.text)
                    
                    for item in stride(from: 0, to: self.check.count - 5, by: 5){
                        let value = Int.random(in: item..<item+5)
                        self.check[value].1 = false
                    }
                    
                    var average: Double = 0
                    for item in self.check {
                        if item.1 {
                            average += 1
                        }
                    }
                    
                    self.correctness = average / Double(self.check.count)
                    
                    self.averagePause = transcription.averagePauseDuration
                    self.speakingRate = transcription.speakingRate
                    
                    var pitchVoicingArray: Array<Double> = []
                    var jitterArray: Array<Double> = []
                    var shimmerArray: Array<Double> = []
                    
                    /*
                     for segment in result!.bestTranscription.segments {
                     guard let voiceAnalytics = segment.voiceAnalytics else { continue }
                     pitchVoicingArray = voiceAnalytics.voicing.acousticFeatureValuePerFrame
                     jitterArray = voiceAnalytics.jitter.acousticFeatureValuePerFrame
                     shimmerArray = voiceAnalytics.shimmer.acousticFeatureValuePerFrame
                     }
                     */
                    
                    self.jitter = self.getAverage(array: jitterArray)
                    self.shimmer = self.getAverage(array: shimmerArray)
                    self.pitchVoicing = self.getAverage(array: pitchVoicingArray)
                    
                    self.postRequestCreateNewAttempt()
                }
            }
        }
    }
    
    private func postRequestCreateNewAttempt() {
        var request = URLRequest(url: URL(string: "http://37.230.114.248/Attempt")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        struct CreateAttemptRequest: Encodable {
            var topicId: Int
            var speakingRate: Double
            var startTime: String
            var finishTime: String
            var ext: String
            var recording: Array<UInt8>
            var pronouncedText: String
            var correctness: Double
            var averagePause: Double
            var shimmer: Double
            var jitter: Double
            var pitchVoicing: Double
        }
        
        let params: CreateAttemptRequest = CreateAttemptRequest(topicId: id, speakingRate: 123.4, startTime: startTime!, finishTime: finishTime!, ext: ext, recording: recording!, pronouncedText: pronouncedText!, correctness: correctness!, averagePause: 87.2, shimmer: 1, jitter: 1, pitchVoicing: 1);
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(params)
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                if responseError != nil {
                    print("responseError: ", responseError.debugDescription as Any)
                    return
                }
                
                if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                    print("response: ", utf8Representation)
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode != 200 {
                            DispatchQueue.main.async {
                                print("WOW")//self.addAlert(alertTitle: "Validation error", alertMessage: utf8Representation)
                            }
                            
                            return
                        } else {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Successfully!",
                                                                        message: "Your attempt has been saved",
                                                                        preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                                    UIAlertAction in NSLog("OK")
                                }
                                
                                alertController.addAction(okAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    } else {
                        print("No readable data received in response CREATE USER")
                    }
                }
            }
            
            task.resume()
            
        } catch {
            print("Something was wrong with post request for registration")
        }
    }
    
    func checkCorrectSpokenText(sourceText: String, spokenText: String) -> [(String, Bool)] {
        var arrayOfWordsForSourceText: Array<String> = []
        for item in sourceText.components(separatedBy: [" ", "."]) {
            if item != "" {
                arrayOfWordsForSourceText.append(item)
            }
        }
        
        let arrayOfWordsForSpokenText = spokenText.split(separator: " ")
        
        var params: [(String, Bool)] = []
        
        var indexSourceText: Int = 0
        var indexSpokenText: Int = 0
        
        let lengthSourceText = arrayOfWordsForSourceText.count
        let lengthSpokenText = arrayOfWordsForSpokenText.count
        
        for n in 0 ... (lengthSourceText - 1) {
            
            // No words ever
            if indexSpokenText == -1 {
                params.append((arrayOfWordsForSourceText[indexSourceText], false))
                indexSourceText += 1
            } else if indexSpokenText == 0 {
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 3
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 2] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 4
                } else {
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    // indexSpokenText += 1
                }
            } else if indexSpokenText == lengthSpokenText - 1 { // the 2 last
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText = -1 // no words in spoken array
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    indexSpokenText = -1 // no words in spoken array
                }
            } else if indexSpokenText == lengthSpokenText - 2 { // the 3 last
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText = -1 // no words in spoken array
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    //indexSpokenText += 1
                }
            } else if indexSpokenText == lengthSpokenText - 3 { // the 4 last
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 2] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText = -1 // no words in spoken array
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    //indexSpokenText += 1
                }
            } else if indexSpokenText == lengthSpokenText - 4 { // the 5 last
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 3
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 2] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 3
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    //indexSpokenText += 1
                }
            } else { // NORMMMMMM
                if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText - 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 1
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 2
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 1] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 3
                } else if arrayOfWordsForSourceText[indexSourceText] == arrayOfWordsForSpokenText[indexSpokenText + 2] {
                    params.append((arrayOfWordsForSourceText[indexSourceText], true))
                    indexSourceText += 1
                    indexSpokenText += 4
                } else { // NOTHING GOOOOOO
                    params.append((arrayOfWordsForSourceText[indexSourceText], false))
                    indexSourceText += 1
                    //indexSpokenText += 1
                }
            }
            
            //print("The word '\(params[n].0)' is \(params[n].1) recognized")
        }
        
        return (params)
    }
    
    // MARK: Actions
    
    @IBAction func saveTopic(_ sender: Any) {
        
    }
    
    // MARK: Private methods
    
    private func setViewElements() {
        guard let configurationModel = self.configurationModel else { return }
        self.id = configurationModel.id
        self.titleLabel.text = configurationModel.titleText
        self.categoryLabel.text = configurationModel.categoryText
        self.levelLabel.text = configurationModel.levelText
        self.descriptionTextView.text = configurationModel.descriptionText
        self.modelAnswerTextView.text = configurationModel.modelAnswerText
    }
    
    private func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        return documentDirectory
    }
    
    private func getAverage(array: Array<Double>) -> Double {
        var sum: Double = 0
        
        for item in array {
            sum += item
        }
        
        return sum / Double(array.count)
    }
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Public methods
    
    public func setConfigurationModel(configurationModel: ConfigurationModel) {
        self.configurationModel = configurationModel
    }
    
    // MARK: Loading the view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewElements()
        fetchAuthToken()
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission {
            (hasPermission) in
            if hasPermission {
                print("ACCEPTED")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    /*
     // MARK: Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
