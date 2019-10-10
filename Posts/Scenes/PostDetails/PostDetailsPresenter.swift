//
//  PostDetailsPresenter.swift
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

protocol PostDetailsPresentationLogic {
    func presentPost(response: PostDetails.GetPost.Response)
    func presentToggleFavorite(response: PostDetails.ToggleFavorite.Response)
    func presentUpdatePostsList(response: PostDetails.UpdatePostsList.Response)
}

class PostDetailsPresenter: PostDetailsPresentationLogic {
    weak var viewController: PostDetailsDisplayLogic?
    
    // MARK: PresentPost
    func presentPost(response: PostDetails.GetPost.Response) {
        let body = response.post.body
        let displayedPost = PostDetails.GetPost.ViewModel.DisplayedPost(body: body, isFavorite: response.post.isFavorite)

        let viewModel = PostDetails.GetPost.ViewModel(displayedPost: displayedPost, user: response.user)
        viewController?.displayPost(viewModel: viewModel)
    }

    func presentUpdatePostsList(response: PostDetails.UpdatePostsList.Response) {
        let viewModel = PostDetails.UpdatePostsList.ViewModel()

        viewController?.displayUpdatePostsList(viewModel: viewModel)
    }

    func presentToggleFavorite(response: PostDetails.ToggleFavorite.Response) {
        let body = response.post.body
        let displayedPost = PostDetails.GetPost.ViewModel.DisplayedPost(body: body, isFavorite: response.post.isFavorite)

        let viewModel = PostDetails.ToggleFavorite.ViewModel(displayedPost: displayedPost, user: response.user)
        viewController?.displayToggleFavorite(viewModel: viewModel)
    }
}
