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
    
    var title: String
    var category: String
    var level: String
    
    // MARK: Initialization
    
    init?(title: String, category: String, level: String) {
        
        // Initialization should fail if there is no title, category or level.
        if title.isEmpty || category.isEmpty || level.isEmpty {
            return nil
        }
            
        // Initialize stored properties.
        self.title = title
        self.category = category
        self.level = level
    }
    
}
