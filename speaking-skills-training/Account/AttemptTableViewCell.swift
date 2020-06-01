//
//  AttemptTableViewCell.swift
//  speaking-skills-training
//
//  Created by vikiwai on 20.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class AttemptTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var scoreLabel: UILabel! // 1
    @IBOutlet weak var listeningButton: UIButton!
    
    var mistakes: [(String, Bool)]!
    
    weak var delegate : AttemptTableViewCellDelegate?
    
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
    
    var attemptId: Int!
    
    var bytes: Array<UInt8>?
    
    var path: URL!
    var player: AVAudioPlayer?
    var isPlaying: Bool = false
    
    // MARK: Actions
    
    @IBAction func didListeningButtonTapped(_ sender: Any) {
        if !isPlaying {
            fetchAuthToken()
            getRequestRecord()
            listeningButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
        } else {
            listeningButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            player?.stop()
            isPlaying = false
        }
    }
    
    @IBAction func didCheckMistakesButtonTapped(_ sender: Any) {
        self.delegate?.attemptTableViewCell(self, mistakes: mistakes, correctness: correctSpokenTextLabel.text!)
    }
    
    // MARK: Score properties
    
    @IBOutlet weak var correctSpokenTextLabel: UILabel! // 2
    @IBOutlet weak var correctPausesLabel: UILabel! // 3
    @IBOutlet weak var pitchLabel: UILabel! // 4
    @IBOutlet weak var jitterLabel: UILabel! // 5
    @IBOutlet weak var shimmerLabel: UILabel! // 6
    @IBOutlet weak var speechSpeedLabel: UILabel! // 7
    @IBOutlet weak var vocabularyLevelLabel: UILabel! // 8
    
    // MARK: Server methods
    
    private func getRequestRecord() {
        var request = URLRequest(url: URL(string: "http://37.230.114.248/Attempt/get_record?attemptId=\(attemptId!)")!)
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
            
            struct Bytes: Decodable {
                var data: String
            }
            
            do {
                let apiresult = try decoder.decode(Bytes.self, from: responseData!)
                let data: [UInt8] = Array(Data(base64Encoded: apiresult.data)!)
                
                DispatchQueue.main.async {
                    self.bytes = data
                }
            } catch {
                print("Something was wrong with getting list of topics", error)
            }
            self.playSound()

        }
        
        task.resume()
    }
    
    // MARK: Private function
    
    func playSound() {
        isPlaying = true
        
        //guard let url = path else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let audioData = Data(self.bytes!)
            
            player = try AVAudioPlayer(data: audioData, fileTypeHint: AVFileType.m4a.rawValue)
            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol AttemptTableViewCellDelegate: AnyObject {
    func attemptTableViewCell(_ cell: AttemptTableViewCell, mistakes: [(String, Bool)], correctness: String)
}
