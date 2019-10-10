//
//  PostDetailsInteractor.swift
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

protocol PostDetailsBusinessLogic {
    func doSomething(request: PostDetails.Something.Request)
}

protocol PostDetailsDataStore {
    var post: Post! { get set }
}

class PostDetailsInteractor: PostDetailsBusinessLogic, PostDetailsDataStore {
    var presenter: PostDetailsPresentationLogic?
    var worker: PostDetailsWorker?
    var post: Post!

    // MARK: Do something

    func doSomething(request: PostDetails.Something.Request) {
        worker = PostDetailsWorker()
        worker?.doSomeWork()

        let response = PostDetails.Something.Response()
        presenter?.presentSomething(response: response)
    }
}