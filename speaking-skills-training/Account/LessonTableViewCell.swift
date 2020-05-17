//
//  LessonTableViewCell.swift
//  speaking-skills-training
//
//  Created by vikiwai on 16.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class LessonTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var levelLable: UILabel!
    
    @IBOutlet weak var didTapArchiveButton: UIButton!
    
    @IBAction func didTapRecordButton(_ sender: Any) {
    }
    
    @IBAction func showArchive(_ sender: Any) {
        
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
