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

class TopicViewController: UIViewController, AVAudioRecorderDelegate {
    
    struct ConfigurationModel {
        public let topicsNumber: Int
        public let titleText: String
        public let categoryText: String
        public let levelText: String
        public let desriptionText: String
        public let rulesText: String
        public let modelAnswerText: String
    }

    // MARK: Properties
    
    var number: Int!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var rulesTextView: UITextView!
    @IBOutlet weak var modelAnswerTextView: UITextView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startRecordingButton: UIButton!
    
    var configurationModel: ConfigurationModel?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var recordsNumber: Int = 0
    
    // MARK: Analysis properties
    
    var path: URL!
    var text: String!
    
    // MARK: Time Counter
    
    var seconds = 0 // This variable will hold a starting value of seconds. It could be any amount above 0.
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
        seconds += 1 // This will decrement(count down)the seconds.
        if seconds >= 120 {
            timeLabel.textColor = .red
        }
        timeLabel.text = timeString(time: TimeInterval(seconds)) //This will update the label.
    }
    
    func stopTimer() {
        timer.invalidate()
        
        seconds = 0 // Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
        timeLabel.textColor = .black
        timeLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    // MARK: Actions
    
    @IBAction func didTapStartRecordingButton(_ sender: Any) {
        
        // Check if we have an active recorder
        if audioRecorder == nil {
            recordsNumber += 1
            
            let filename = getDirectory().appendingPathComponent("\(recordsNumber).m4a")
            path = filename
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 1200, AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start audio recording
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
            // Stop audio recording
            
            //print(audioRecorder.currentTime)
            audioRecorder.stop()
            audioRecorder = nil
            
            stopTimer()
            
            startRecordingButton.setTitle("Start recording", for: .normal)
            
            recordingProcess(path: path)
            //print(self.text ?? "NIL")
        }
    }
    
    private func recordingProcess(path: URL) {
        // Given an audio file at url, the following code transcribes the file and prints the results
        
        SFSpeechRecognizer.requestAuthorization {
            
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                if let path = self.path {
                print("Path to request " + "\(path)")
            }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
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
        
        let request = SFSpeechURLRecognitionRequest(url: url) // for reading from a file.
    
        recognizer.recognitionTask(with: request) { (result, error) in //  generate recognition tasks and return results
            //print(error)
            
            if let transcription = result?.bestTranscription {
                self.text = transcription.formattedString
                if result!.isFinal {
                    print(self.text ?? "NULLL")
                }
            }
        }
    }
    
    @IBAction func saveTopic(_ sender: Any) {
        
    }
    
    // MARK: Private methods
    
    private func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        return documentDirectory // Get the path to directory.
    }
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil) // Display an alert.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewElements()

        // Do any additional setup after loading the view.
        
        // Setting up session.
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
    
    private func setViewElements() {
        guard let configurationModel = self.configurationModel else { return }
        self.number = configurationModel.topicsNumber
        self.titleLabel.text = configurationModel.titleText
        self.categoryLabel.text = configurationModel.categoryText
        self.levelLabel.text = configurationModel.levelText
        self.descriptionTextView.text = configurationModel.desriptionText
        self.rulesTextView.text = configurationModel.rulesText
        self.modelAnswerTextView.text = configurationModel.modelAnswerText
    }
    
    public func setConfigurationModel(configurationModel: ConfigurationModel) {
        self.configurationModel = configurationModel
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


