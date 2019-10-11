//
//  PostDetailsWorker.swift
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
import Alamofire
import RealmSwift

class PostDetailsWorker {
    private let userUrl = "https://jsonplaceholder.typicode.com/users/"
    private let commentsUrl = "https://jsonplaceholder.typicode.com/posts/%@/comments"

    /**
     fetch comments from service
     - parameter postId: id of the post you want comments from
     - parameter completionHandler: block were an array of comments is sent
     */
    func fetchComments(postId: Int, completionHandler: @escaping (([Comment]) -> ())) {
        let url = String(format: commentsUrl, "\(postId)")

        Alamofire.request(url).responseJSON { (dataResponse) in
            if let data = dataResponse.data {
                let decoder = JSONDecoder()

                do {
                    let comments = try decoder.decode([Comment].self, from: data)
                    completionHandler(comments)
                } catch {
                    print("error decoding user")
                    print(error)
                    completionHandler([])
                }
            }
        }
    }

    /**
     fetch User from service
     - parameter id: id of the user
     - parameter completionHandler: block were the user is sent
     */
    func fetchUser(id: Int, completionHandler: @escaping ((User) -> ())) {
        Alamofire.request("\(userUrl)\(id)").responseJSON { (dataResponse) in
            if let data = dataResponse.data {
                let decoder = JSONDecoder()

                do {
                    let user = try decoder.decode(User.self, from: data)
                    completionHandler(user)
                } catch {
                    print("error decoding user")
                    print(error)
                }
            }
        }
    }

    func markReadPost(post: Post) {
        do {
            let realm = try Realm()
            try realm.write {
                post.isUnread = false
            }
        } catch {
            print(error)
        }
    }

    func toggleFavoritePost(post: Post) {
        do {
            let realm = try Realm()
            try realm.write {
                post.isFavorite = !post.isFavorite
            }
        } catch {
            print(error)
        }
    }


}
