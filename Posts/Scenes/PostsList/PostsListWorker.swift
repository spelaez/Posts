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
     - parameter completionHandler: block were an array of post will be sent once the fetch is completed.
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

    /**
     get posts from realm
     - returns: array of posts from local persistence
     */
    func fetchPostsFromCache() -> [Post] {
        return Array(realm!.objects(Post.self))
    }

    /**
     filter posts
     - parameter posts: array of posts to be filtered
     - parameter filter: type of filter to apply
     - returns: array of posts filtered
     */
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
     - parameter posts: array of posts where the post will be deleted
     - returns: index of the deleted post
     */
    func deletePost(post: Post) {
        do {
            try realm?.write {
                realm?.delete(post)
            }

        } catch {
            print(error)
        }
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

    private func markUnreadPost(post: Post) {
        post.isUnread = true
    }
}
