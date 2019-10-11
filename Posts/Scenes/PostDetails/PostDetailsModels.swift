//
//  PostDetailsModels.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/10/19.
//  Copyright (c) 2019 Santiago Pelaez Rua. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PostDetails {
    
    // MARK: Use cases
    enum GetComments {
        struct Request {
        }

        struct Response {
            var comments: [Comment]
        }

        struct ViewModel {
            struct DisplayedComment {
                var body: String
            }

            var displayedComments: [DisplayedComment]
        }
    }

    enum GetPost {
        struct Request {
        }

        struct Response {
            var post: Post
            var user: User
        }

        struct ViewModel {
            struct DisplayedPost {
                var body: String
                var isFavorite: Bool
            }

            var displayedPost: DisplayedPost
            var user: User
        }
    }

    enum ToggleFavorite {
        struct Request {
        }

        struct Response {
            var post: Post
            var user: User
        }

        struct ViewModel {
            var displayedPost: GetPost.ViewModel.DisplayedPost
            var user: User
        }
    }

    enum UpdatePostsList {
        struct Request {
        }

        struct Response {
        }

        struct ViewModel {
        }
    }
}
