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
    var recordTime: Double?
    var recordDate: String?
    
    // MARK: Analysis properties
    
    var recordPath: URL!
    var text: String!
    
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
                
                runTimer()
                
                startRecordingButton.setTitle("Stop recording", for: .normal)
            } catch {
                displayAlert(title: "UPS!", message: "Recording failed")
            }
        } else {
            recordTime = audioRecorder.currentTime
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            recordDate = formatter.string(from: date)
            
            audioRecorder.stop()
            audioRecorder = nil
            
            stopTimer()
            
            startRecordingButton.setTitle("Start recording", for: .normal)
            
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
        
        self.transcribeFile(url: path, locale: Locale.init(identifier: "en_GB"))
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
                
                if result!.isFinal {
                    print(self.text ?? "NULLL")
                    var attempt = Attempt.init(path: url, title: self.titleLabel.text!, number: self.recordNumber, date: self.recordDate!, text: self.text, time: self.recordTime!)
                    
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
        
        let params: [String: Int] = [
            "topicId": id
        ]
        
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
                                //self.addAlert(alertTitle: "Validation error", alertMessage: utf8Representation)
                            }
                            
                            return
                        } else {
                            DispatchQueue.main.async {
                                //self.postRequestGenerateToken()
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
        
        return documentDirectory // Get the path to directory.
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
