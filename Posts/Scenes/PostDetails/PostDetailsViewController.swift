//
//  PostDetailsViewController.swift
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

protocol PostDetailsDisplayLogic: class {
    func displayPost(viewModel: PostDetails.GetPost.ViewModel)
    func displayUpdatePostsList(viewModel: PostDetails.UpdatePostsList.ViewModel)
    func displayToggleFavorite(viewModel: PostDetails.ToggleFavorite.ViewModel)
}

class PostDetailsViewController: UIViewController, PostDetailsDisplayLogic {
    var interactor: PostDetailsBusinessLogic?
    var router: (NSObjectProtocol & PostDetailsRoutingLogic & PostDetailsDataPassing)?

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = PostDetailsInteractor()
        let presenter = PostDetailsPresenter()
        let router = PostDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()

        let request = PostDetails.GetPost.Request()
        interactor?.getPost(request: request)
    }

    // MARK: Outlets
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    // MARK: Display post
    func displayPost(viewModel: PostDetails.GetPost.ViewModel) {
        updateUI(displayedPost: viewModel.displayedPost, user: viewModel.user)
    }

    func displayToggleFavorite(viewModel: PostDetails.ToggleFavorite.ViewModel) {
        updateUI(displayedPost: viewModel.displayedPost, user: viewModel.user)
    }

    // MARK: Update Posts List
    func displayUpdatePostsList(viewModel: PostDetails.UpdatePostsList.ViewModel) {
        router?.routeToPostsList()
    }

    @objc func updatePostList(sender: UIBarButtonItem) {
        let request = PostDetails.UpdatePostsList.Request()

        interactor?.updatePostsList(request: request)
    }

    // MARK: Toggle Favorite
    @IBAction func toggleFavorite(_ sender: Any) {
        let request = PostDetails.ToggleFavorite.Request()

        interactor?.toggleFavorite(request: request)
    }

    private func configureBackButton() {
        self.navigationItem.hidesBackButton = true
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(updatePostList(sender:)))
        self.navigationItem.leftBarButtonItem = customBackButton
    }

    private func updateUI(displayedPost: PostDetails.GetPost.ViewModel.DisplayedPost, user: User) {
        self.bodyTextView.text = displayedPost.body

        self.usernameLabel.text = user.name
        self.emailLabel.text = user.email
        self.phoneLabel.text = user.phone
        self.websiteLabel.text = user.website

        if displayedPost.isFavorite {
            self.favoriteButton.image = UIImage(systemName: "star.fill")
        } else {
            self.favoriteButton.image = UIImage(systemName: "star")
        }
    }
}
