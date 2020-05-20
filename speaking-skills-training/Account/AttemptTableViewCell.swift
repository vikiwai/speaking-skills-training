//
//  AttemptTableViewCell.swift
//  speaking-skills-training
//
//  Created by vikiwai on 20.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class AttemptTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var listeningButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func didListeningButtonTapped(_ sender: Any) {
    }
    
    // MARK: Score properties
    
    @IBOutlet weak var correctSpokenTextLabel: UILabel!
    @IBOutlet weak var correctPausesLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var jitterLabel: UILabel!
    @IBOutlet weak var shimmerLabel: UILabel!
    @IBOutlet weak var speechSpeedLabel: UILabel!
    @IBOutlet weak var vocabularyLevelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
