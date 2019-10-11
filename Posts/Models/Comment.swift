//
//  Comment.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/10/19.
//  Copyright © 2019 Santiago Pelaez Rua. All rights reserved.
//

import Foundation

struct Comment {
    var id: Int
    var postId: Int
    var body: String
}

extension Comment: Decodable {}
