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
     delete all posts and ask presenter to show an empty list
     */
    func deleteAll(request: PostsList.DeletePosts.Request)

    /**
     deletes a post at the specified index given a request and asks presenter to format the new list
     - parameter request: a Request object containing the index of the post to be deleted
     */
    func delete(request: PostsList.DeletePosts.Request)
}

protocol PostsListDataStore {
    //var name: String { get set }
}

class PostsListInteractor: PostsListBusinessLogic, PostsListDataStore {
    var presenter: PostsListPresentationLogic?
    var worker: PostsListWorker?

    init() {
        worker = PostsListWorker()
    }

    // MARK: Fetch
    func fetch(request: PostsList.FetchPosts.Request) {
        let response = PostsList.FetchPosts.Response(posts: worker?.fetchPosts() ?? [])

        presenter?.presentPosts(response: response)
    }

    // MARK: Delete
    func delete(request: PostsList.DeletePosts.Request) {
        let posts = worker?.deletePost(at: request.index) ?? []
        let response = PostsList.DeletePosts.Response(index: request.index, posts: posts)

        presenter?.presentPosts(response: response)
    }

    func deleteAll(request: PostsList.DeletePosts.Request) {
        worker?.deleteAllPosts()

        presenter?.presentPosts(response: PostsList.DeletePosts.Response(posts: []))
    }
}
