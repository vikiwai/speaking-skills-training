//
//  Attempt.swift
//  speaking-skills-training
//
//  Created by vikiwai on 20.05.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class Attempt: NSObject, Decodable {
    
    // MARK: Properties
    
    var id: Int
    var topicId: Int
    var startTime: String
    var finishTime: String
    var recordAvailable: Bool
    var pronouncedText: String
    var originalText: String
    var speakingRate: Double
    var correctness: Double
    var averagePause: Double
    var shimmer: Double
    var jitter: Double
    var pitchVoicing: Double
    
    // MARK: Initialization
    
    init?(id: Int, topicId: Int, startTime: String, finishTime: String, recordAvailable: Bool, pronouncedText: String, originalText: String, speakingRate: Double, correctness: Double, averagePause: Double, shimmer: Double, jitter: Double, pitchVoicing: Double) {
        self.id = id
        self.topicId = topicId
        self.startTime = startTime
        self.finishTime = finishTime
        self.recordAvailable = recordAvailable
        self.pronouncedText = pronouncedText
        self.originalText = originalText
        self.speakingRate = speakingRate
        self.correctness = correctness
        self.averagePause = averagePause
        self.shimmer = shimmer
        self.jitter = jitter
        self.pitchVoicing = pitchVoicing
    }
}
