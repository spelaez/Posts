//
//  PostDetailsRouter.swift
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

@objc protocol PostDetailsRoutingLogic {
    func routeToPostsList()
}

protocol PostDetailsDataPassing {
    var dataStore: PostDetailsDataStore? { get }
}

class PostDetailsRouter: NSObject, PostDetailsRoutingLogic, PostDetailsDataPassing {
    weak var viewController: PostDetailsViewController?
    var dataStore: PostDetailsDataStore?
    
    // MARK: Routing
    func routeToPostsList() {
        if let dataStore = dataStore,
            let viewController = viewController,
            let destinationVC = viewController.navigationController?.viewControllers.first as? PostsListViewController,
            var destinationDS = destinationVC.router?.dataStore {

            passDataToPostsList(source: dataStore, destination: &destinationDS)
            navigateToPostsList(source: viewController, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    func navigateToPostsList(source: PostDetailsViewController, destination: PostsListViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Passing data
    func passDataToPostsList(source: PostDetailsDataStore, destination: inout PostsListDataStore) {
        destination.updatePost(post: source.post)
    }
}
