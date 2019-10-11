//
//  User.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/10/19.
//  Copyright © 2019 Santiago Pelaez Rua. All rights reserved.
//

import Foundation

struct User: Decodable {
    var name: String
    var email: String
    var phone: String
    var website: String
}
