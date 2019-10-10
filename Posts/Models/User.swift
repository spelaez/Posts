//
//  User.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/10/19.
//  Copyright © 2019 Santiago Pelaez Rua. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var email: String
    var phone: String
    var website: String

    init(name: String, email: String, phone: String, website: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.website = website
    }
}

extension User: Codable {
}
