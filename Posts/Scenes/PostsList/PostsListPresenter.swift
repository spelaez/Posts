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
    func presentSomething(response: PostsList.Something.Response)
}

class PostsListPresenter: PostsListPresentationLogic {
    weak var viewController: PostsListDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: PostsList.Something.Response) {
        let viewModel = PostsList.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
