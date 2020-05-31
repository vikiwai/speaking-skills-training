//
//  LessonTableViewCell.swift
//  speaking-skills-training
//
//  Created by vikiwai on 16.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class LessonTableViewCell: UITableViewCell {

    // MARK: Properties
    
    var topicNumber: Int!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var levelLable: UILabel!
    
   // var topicDescription: String!
   // var topicRules: String!
    var topicModelAnswer: String!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    
    weak var delegate : LessonTableViewCellDelegate?
    
    // MARK: Actions
    
    @IBAction func didTapRecordButton(_ sender: Any) {
        
        self.delegate?.lessonTableViewCell(self, number: topicNumber ?? 0, title: titleLabel.text ?? "", category: categoryLabel.text ?? "", level: levelLable.text ?? "", modelAnswer: topicModelAnswer ?? "")
    }
    
    @IBAction func didTapArchiveButton(_ sender: Any) {
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Add action to perform when the button is tapped
           self.recordButton.addTarget(self, action: #selector(didTapRecordButton(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// Only class object can conform to this protocol (struct/enum can't)
protocol LessonTableViewCellDelegate: AnyObject {
//    func lessonTableViewCell(_ cell: LessonTableViewCell, number: Int, title: String, category: String, level: String, description: String, rules: String, modelAnswer: String)
    func lessonTableViewCell(_ cell: LessonTableViewCell, number: Int, title: String, category: String, level: String, modelAnswer: String)
}
