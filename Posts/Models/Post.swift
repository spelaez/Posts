//
//  Post.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/10/19.
//  Copyright © 2019 Santiago Pelaez Rua. All rights reserved.
//

import Foundation

struct Post {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    var isFavorite: Bool = false
    var isUnread: Bool = false

    init(userId: Int, id: Int, title: String, body: String, isFavorite: Bool = false, isUnread: Bool = false) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
        self.isUnread = isUnread
    }
}

extension Post: Decodable {
    enum CodingKeys: String, CodingKey {
        case userId, id, title, body, isFavorite, isUnread
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userId = try container.decode(Int.self, forKey: .userId)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        isFavorite = false
        isUnread = false
    }
}
