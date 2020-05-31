//
//  Lesson.swift
//  speaking-skills-training
//
//  Created by vikiwai on 17.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class Lesson: NSObject, Decodable {
    
    // MARK: Properties
    
    var id: Int
    var theme: String
    var name: String
    var text: String
    var levelName: String
    //var questions: String

    // MARK: Initialization
    
//    init?(id: Int, theme: String, name: String, text: String, levelName: String, questions: String) {
//        self.id = id
//        self.theme = theme
//        self.name = name
//        self.text = text
//        self.levelName = levelName
//        self.questions = questions
//    }
    
    init?(id: Int, theme: String, name: String, text: String, levelName: String) {
        self.id = id
        self.theme = theme
        self.name = name
        self.text = text
        self.levelName = levelName
    }
}
