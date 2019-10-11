//
//  PostsListInteractor.swift
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

protocol PostsListBusinessLogic {
    /**
     fetch posts given a request and asks presenter to format them
     */
    func fetch(request: PostsList.FetchPosts.Request)

    /**
     filter posts and ask presenter to format them
     - parameter request: Request object containint the type of filter to apply (all, favorites)
     */
    func filter(request: PostsList.FilterPosts.Request)

    /**
     delete all posts and ask presenter to show an empty list
     */
    func deleteAll(request: PostsList.DeletePosts.Request)

    /**
     deletes a post at the specified index given a request and asks presenter to format the new list
     - parameter request: a Request object containing the index of the post to be deleted
     */
    func delete(request: PostsList.DeletePosts.Request)

    /**
     marks a post as read
     - parameter id: Id for the post to be marked as read
     */
    func markPostAsRead(id: Int)
}

protocol PostsListDataStore {
    var posts: [Post] { get }
    func updatePost(post: Post)
}

class PostsListInteractor: PostsListBusinessLogic, PostsListDataStore {
    var presenter: PostsListPresentationLogic?
    var worker: PostsListWorker?
    var posts: [Post] = []
    var favoritePosts: [Post] = []
    private var currentFilter: PostsList.FilterPosts.Filter = .all

    init() {
        worker = PostsListWorker()
    }

    // MARK: Fetch
    func fetch(request: PostsList.FetchPosts.Request) {
        var response: PostsList.FetchPosts.Response

        if posts.count > 0 {
            if currentFilter == .favorites {
                let filteredPosts = worker?.filter(posts: posts, by: currentFilter) ?? []
                response = PostsList.FetchPosts.Response(posts: filteredPosts)
            } else {
                response = PostsList.FetchPosts.Response(posts: posts)
            }

            self.presenter?.presentPosts(response: response)
        } else {
            worker?.fetchPosts(completionHandler: { [weak self] posts in
                self?.posts = posts
                self?.markUnreadPosts()

                let response = PostsList.FetchPosts.Response(posts: self?.posts ?? [])
                self?.presenter?.presentPosts(response: response)
            })
        }
    }

    // MARK: Filter
    func filter(request: PostsList.FilterPosts.Request) {
        currentFilter = request.filter
        var response: PostsList.FilterPosts.Response

        if currentFilter == .favorites {
            let filteredPosts = worker?.filter(posts: posts, by: currentFilter) ?? []
            response = PostsList.FilterPosts.Response(posts: filteredPosts)
        } else {
            response = PostsList.FilterPosts.Response(posts: posts)
        }

        presenter?.presentFilteredPosts(response: response)
    }

    // MARK: Delete
    func delete(request: PostsList.DeletePosts.Request) {
        var response: PostsList.DeletePosts.Response

        if let id = request.id {
            worker?.deletePost(id: id, on: &posts)

            if currentFilter == .favorites {
                let filteredPosts = worker?.filter(posts: posts, by: currentFilter) ?? []
                response = PostsList.DeletePosts.Response(id: id, posts: filteredPosts)
            } else {
                response = PostsList.DeletePosts.Response(id: id, posts: posts)
            }

            presenter?.presentPosts(response: response)
        }
    }

    // MARK: Mark post read
    func markPostAsRead(id: Int) {
        var response: PostsList.FetchPosts.Response

        if let index = posts.firstIndex(where: { $0.id == id }) {
            posts[index].isUnread = false
        }

        if currentFilter == .favorites {
            let filteredPosts = worker?.filter(posts: posts, by: currentFilter) ?? []
            response = PostsList.FetchPosts.Response(posts: filteredPosts)
        } else {
            response = PostsList.FetchPosts.Response(posts: posts)
        }

        presenter?.presentPosts(response: response)
    }

    // MARK: Delete all posts
    func deleteAll(request: PostsList.DeletePosts.Request) {
        self.posts = []

        presenter?.presentPosts(response: PostsList.DeletePosts.Response(posts: []))
    }

    // MARK: Update Post
    func updatePost(post: Post) {
        if let indexOfPost = posts.firstIndex(where: { $0.id == post.id }) {
            posts[indexOfPost] = post
        }
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
