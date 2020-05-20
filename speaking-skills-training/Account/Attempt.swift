//
//  Attempt.swift
//  speaking-skills-training
//
//  Created by vikiwai on 20.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class Attempt {
    
    // MARK: Main properties
    
    var path: URL
    var title: String
    var number: Int
    var date: String
    
    // MARK: Defined properties
    
    var text: String
    var time: Double
    
    // MARK: Score properties
    
    var correctSpokenText: Double = 0
    var mistakes: Array<String> = []
    var pauses: Double = 0
    var pitch: Double = 0
    var jitter: Double = 0
    var shimmer: Double = 0
    var speed: Double = 0
    var vocabularyLevel: String = ""
    
    // MARK: Initialization
    
    init?(path: URL, title: String, number: Int, date: String, text: String, time: Double) {
        
        // Initialization should fail if there are empty main properties.
        if path.description.isEmpty || title.isEmpty || number == 0 || date.isEmpty || text.isEmpty || time == 0 {
            return nil
        }

        // Initialize stored properties.
        self.path = path
        self.title = title
        self.number = number
        self.date = date
        self.text = text
        self.time = time
    }
}
