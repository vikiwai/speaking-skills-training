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
    var topicModelAnswer: String!
    // var topicDescription: String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var levelLable: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    
    // MARK: Delegates
    
    weak var delegate : LessonTableViewCellDelegate?
    
    // MARK: Actions
    
    @IBAction func didTapRecordButton(_ sender: Any) {
        self.delegate?.lessonTableViewCell(self, number: topicNumber ?? 0, title: titleLabel.text ?? "", category: categoryLabel.text ?? "", level: levelLable.text ?? "", modelAnswer: topicModelAnswer ?? "")
    }
    
    @IBAction func didTapArchiveButton(_ sender: Any) {
        self.delegate?.lessonTableViewCell(self)
    }
    
    // MARK: Overrided methods
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.recordButton.addTarget(self, action: #selector(didTapRecordButton(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: Protocols

protocol LessonTableViewCellDelegate: AnyObject {
    func lessonTableViewCell(_ cell: LessonTableViewCell, number: Int, title: String, category: String, level: String, modelAnswer: String)
    func lessonTableViewCell(_ cell: LessonTableViewCell)
}
