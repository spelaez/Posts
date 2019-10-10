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

class PostsListWorker {
    private var postsUrl = "https://jsonplaceholder.typicode.com/posts"
    private var posts: [PostsList.Post] = []
    private var currentFilter: PostsList.FilterPosts.Filter = .all

    /**
     fetch posts from network or cache when available
     - returns: An array of posts
     */
    func fetchPosts(completionHandler: @escaping (([PostsList.Post]) -> ())){
        Alamofire.request(postsUrl).responseJSON { dataResponse in
                if let data = dataResponse.data {
                    let decoder = JSONDecoder()

                    do {
                        self.posts = try decoder.decode([PostsList.Post].self, from: data)
                        self.markUnreadPosts()
                        completionHandler(self.postsFilteredBy(self.currentFilter))
                    } catch {
                        print("error trying to decode response")
                        print(error.localizedDescription)
                    }
                }
            }
        }

    func postsFilteredBy(_ filter: PostsList.FilterPosts.Filter) -> [PostsList.Post] {
        currentFilter = filter

        switch filter {
        case .all:
            return posts
        case .favorites:
            return posts.filter { $0.isFavorite }
        }
    }

    /**
     delete a single post
     - parameter id: id for the post to be deleted as Int
     - returns: An array of posts without the deleted post
     */
    func deletePost(id: Int) -> [PostsList.Post] {
        if let index = posts.firstIndex(where: { $0.id == id }) {
            posts.remove(at: index)
        }

        return postsFilteredBy(currentFilter)
    }

    /**
     deletes all posts
     */
    func deleteAllPosts() {
        posts = []
    }

    /**
     marks the first 20 posts as unread
     */
    private func markUnreadPosts() {
        var counter = 0
        for i in 0..<posts.count {
            if counter < 20 {
                posts[i].isUnread = true
            }

            counter += 1
        }
    }
}
