//
//  PostsListPresenter.swift
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

protocol PostsListPresentationLogic {
    /**
     formats and asks viewController to display posts from a given response
     - parameter response: Response object containing posts data
     */
    func presentPosts(response: PostsList.FetchPosts.Response)
    func presentPosts(response: PostsList.DeletePosts.Response)
    func presentFilteredPosts(response: PostsList.FilterPosts.Response)
}

class PostsListPresenter: PostsListPresentationLogic {
    weak var viewController: PostsListDisplayLogic?
    private var posts: [Post]!
    
    // MARK: Present posts
    func presentPosts(response: PostsList.FetchPosts.Response) {
        viewController?.displayPosts(viewModel: PostsList.FetchPosts.ViewModel(posts: response.posts))
    }

    func presentPosts(response: PostsList.DeletePosts.Response) {
        viewController?.displayPosts(viewModel: PostsList.DeletePosts.ViewModel(id: response.id, posts: response.posts))
    }

    func presentFilteredPosts(response: PostsList.FilterPosts.Response) {
        viewController?.displayFilteredPosts(viewModel: PostsList.FilterPosts.ViewModel(posts: response.posts))
    }

}
