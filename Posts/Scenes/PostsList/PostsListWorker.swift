//
//  PostsListWorker.swift
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
import Alamofire
import RealmSwift

class PostsListWorker {
    private var postsUrl = "https://jsonplaceholder.typicode.com/posts"
    private var realm: Realm?

    init() {
        do {
            self.realm = try Realm()
        } catch {
            print("couldn't instantiate realm")
            print(error)
        }
    }

    /**
     fetch posts from network or cache when available
     - returns: An array of posts
     */
    func fetchPosts(completionHandler: @escaping (([Post]) -> ())){
        let cachedPosts = fetchPostsFromCache()

        if cachedPosts.isEmpty {
            Alamofire.request(postsUrl).responseJSON { dataResponse in
                if let data = dataResponse.data {
                    let decoder = JSONDecoder()

                    do {
                        let posts = try decoder.decode([Post].self, from: data)
                        var counter = 0

                        for post in posts {
                            try self.realm?.write {
                                if counter < 20 {
                                    self.markUnreadPost(post: post)
                                    counter += 1
                                }
                                self.realm?.add(post)
                            }
                        }

                        completionHandler(posts)
                    } catch {
                        print("error trying to decode response")
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            completionHandler(cachedPosts)
        }
    }

    private func fetchPostsFromCache() -> [Post] {
        return Array(realm!.objects(Post.self))
    }

    func filter(posts: [Post], by filter: PostsList.FilterPosts.Filter) -> [Post] {
        switch filter {
        case .all:
            return posts
        case .favorites:
            let filteredPosts = realm?.objects(Post.self).filter { $0.isFavorite }

            return Array(filteredPosts!)
        }
    }

    /**
     delete a single post from realm
     - parameter id: id for the post to be deleted as Int
     - returns: An array of posts without the deleted post
     */
    func deletePost(id: Int, on posts: inout [Post]) -> Int? {
        if let index = posts.firstIndex(where: { $0.id == id }) {
            let removedPost = posts.remove(at: index)

            do {
                try realm?.write {
                    realm?.delete(removedPost)
                }

                return index
            } catch {
                print(error)
            }
        }

        return nil
    }

    /**
     deletes all given posts from realm
     */
    func deleteAllPosts() {
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch {
            print(error)
        }
    }

    func updatePost(post: Post) {
        do {
            try realm?.write {
                realm?.add(post, update: .modified)
            }
        } catch {
            print("couldn't update post")
            print(error)
        }
    }

    func markUnreadPost(post: Post) {
        post.isUnread = true
    }
}
