//
//  AttemptTableViewCell.swift
//  speaking-skills-training
//
//  Created by vikiwai on 20.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import AVFoundation

class AttemptTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var listeningButton: UIButton!
    
    var path: URL!
    var player: AVAudioPlayer?
    var isPlaying: Bool = false
    
    // MARK: Actions
    
    @IBAction func didListeningButtonTapped(_ sender: Any) {
        if !isPlaying {
            listeningButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            playSound()
        } else {
            listeningButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            player?.stop()
            isPlaying = false
        }
    }
    
    // MARK: Score properties
    
    @IBOutlet weak var correctSpokenTextLabel: UILabel!
    @IBOutlet weak var correctPausesLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var jitterLabel: UILabel!
    @IBOutlet weak var shimmerLabel: UILabel!
    @IBOutlet weak var speechSpeedLabel: UILabel!
    @IBOutlet weak var vocabularyLevelLabel: UILabel!
    
    // MARK: Private function
    
    func playSound() {
        isPlaying = true
        
        guard let url = path else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            //player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
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
