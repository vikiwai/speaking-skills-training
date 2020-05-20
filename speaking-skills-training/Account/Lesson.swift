//
//  Lesson.swift
//  speaking-skills-training
//
//  Created by vikiwai on 17.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class Lesson {
    
    // MARK: Properties
    
    var number: Int
    var title: String
    var category: String
    var level: String
    var description: String
    var rules: String
    var modelAnswer: String
    
    // MARK: Initialization
    
    init?(number: Int, title: String, category: String, level: String, description: String, rules: String, modelAnswer: String) {
        
        // Initialization should fail if there are empty properties.
        if number == 0 || title.isEmpty || category.isEmpty || level.isEmpty || description.isEmpty || rules.isEmpty || modelAnswer.isEmpty {
            return nil
        }
            
        // Initialize stored properties.
        self.number = number
        self.title = title
        self.category = category
        self.level = level
        self.description = description
        self.rules = rules
        self.modelAnswer = modelAnswer
    }
}
