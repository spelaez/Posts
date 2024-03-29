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
    func presentPosts(response: PostsList.FetchPosts.Response)
    func presentPosts(response: PostsList.DeletePost.Response)
    func presentPosts(response: PostsList.DeleteAllPosts.Response)
    func presentFilteredPosts(response: PostsList.FilterPosts.Response)
}

class PostsListPresenter: PostsListPresentationLogic {
    weak var viewController: PostsListDisplayLogic?
    private var posts: [Post]!
    
    // MARK: Present posts
    func presentPosts(response: PostsList.FetchPosts.Response) {
        viewController?.displayPosts(viewModel: PostsList.FetchPosts.ViewModel(posts: response.posts))
    }

    func presentPosts(response: PostsList.DeletePost.Response) {
        viewController?.displayPosts(viewModel: PostsList.DeletePost.ViewModel(posts: response.posts))
    }

    func presentPosts(response: PostsList.DeleteAllPosts.Response) {
        viewController?.displayPosts(viewModel: PostsList.DeleteAllPosts.ViewModel())
    }

    // MARK: Presnet filtered posts
    func presentFilteredPosts(response: PostsList.FilterPosts.Response) {
        viewController?.displayFilteredPosts(viewModel: PostsList.FilterPosts.ViewModel(posts: response.posts))
    }

}
