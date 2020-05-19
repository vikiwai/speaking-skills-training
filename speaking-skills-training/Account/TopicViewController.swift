//
//  TopicViewController.swift
//  speaking-skills-training
//
//  Created by vikiwai on 17.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    // MARK: Actions
    
    @IBAction func didTapStartRecordingButton(_ sender: Any) {
        
        // Check if we have an active recorder
        if audioRecorder == nil {
            recordsNumber += 1
            
            let filename = getDirectory().appendingPathComponent("\(recordsNumber).m4a")
            print(filename)
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 1200, AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                startRecordingButton.setTitle("Stop recording", for: .normal)
            } catch {
                displayAlert(title: "UPS!", message: "Recording failed")
            }
        } else {
            // Stop audio recording
            audioRecorder.stop()
            audioRecorder = nil
            
            startRecordingButton.setTitle("Start recording", for: .normal)
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


