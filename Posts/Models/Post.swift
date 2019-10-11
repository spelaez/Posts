//
//  Post.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/10/19.
//  Copyright © 2019 Santiago Pelaez Rua. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Post: Object, Decodable {
    // MARK: Persisted properties
    dynamic var userId = 0
    dynamic var id = 0
    dynamic var title = ""
    dynamic var body = ""
    dynamic var isFavorite: Bool = false
    dynamic var isUnread: Bool = false

    enum CodingKeys: String, CodingKey {
        case userId, id, title, body
    }

    convenience init(userId: Int, id: Int, title: String, body: String, isFavorite: Bool = false, isUnread: Bool = false) {
        self.init()

        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
        self.isUnread = isUnread
    }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let userId = try container.decode(Int.self, forKey: .userId)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let body = try container.decode(String.self, forKey: .body)

        self.init(userId: userId, id: id, title: title, body: body)
    }

    override class func primaryKey() -> String? {
        "id"
    }
}
