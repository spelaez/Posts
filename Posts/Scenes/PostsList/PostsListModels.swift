//
//  PostsListModels.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/9/19.
//  Copyright (c) 2019 Santiago Pelaez Rua. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PostsList {

    struct Post {
        let userId: String
        let id: String
        let title: String
        let body: String
        let isFavorite: Bool
        let isUnread: Bool
    }
    // MARK: Use cases
    enum FetchPosts {
        struct Request {
        }

        struct Response {
            let posts: [Post]
        }

        struct ViewModel {
            let posts: [Post]
        }
    }
}
