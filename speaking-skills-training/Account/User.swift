//
//  User.swift
//  speaking-skills-training
//
//  Created by vikiwai on 05.06.2020.
//  Copyright © 2020 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class User: NSObject, Decodable {
    
    // MARK: Properties
    
    var login: String
    var name: String
    var surname: String
    var email: String
    var creationDate: String

    // MARK: Initialization
    
    init?(login: String, name: String, surname: String, email: String, creationDate: String) {
        self.login = login
        self.name = name
        self.surname = surname
        self.email = email
        self.creationDate = creationDate
    }
}
