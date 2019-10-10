//
//  PostsListViewController.swift
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

protocol PostsListDisplayLogic: class {
    /**
     display posts on a table view
     - parameter viewModel: a ViewModel object containing an array of posts to display
     */
    func displayPosts(viewModel: PostsList.FetchPosts.ViewModel)

    /**
     display posts on a table view after a deletion
     - parameter viewModel: a Viewmodel object containing an array of posts to display
     */
    func displayPosts(viewModel: PostsList.DeletePosts.ViewModel)

    func displayFilteredPosts(viewModel: PostsList.FilterPosts.ViewModel)
}

class PostsListViewController: UIViewController, PostsListDisplayLogic {
    var interactor: PostsListBusinessLogic?
    var router: (NSObjectProtocol & PostsListRoutingLogic & PostsListDataPassing)?

    var posts: [Post] = []
    
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
        let interactor = PostsListInteractor()
        let presenter = PostsListPresenter()
        let router = PostsListRouter()
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

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var postsSegmentedControl: UISegmentedControl!

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        interactor?.fetch(request: PostsList.FetchPosts.Request())
    }

    // MARK: IBActions
    @IBAction func reloadPosts(_ sender: Any) {
        let request = PostsList.FetchPosts.Request()

        interactor?.fetch(request: request)
    }

    @IBAction func deleteAllPosts(_ sender: Any) {
        let request = PostsList.DeletePosts.Request()
        interactor?.deleteAll(request: request)
    }

    @IBAction func postsSegmentedControlDidChange(_ sender: UISegmentedControl) {
        var request: PostsList.FilterPosts.Request

        if sender.selectedSegmentIndex == 0 {
            request = PostsList.FilterPosts.Request(filter: .all)
        } else {
            request = PostsList.FilterPosts.Request(filter: .favorites)
        }

        interactor?.filter(request: request)
    }

    // MARK: Display posts
    func displayPosts(viewModel: PostsList.FetchPosts.ViewModel) {
        posts = viewModel.posts
        postsTableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
    }

    func displayPosts(viewModel: PostsList.DeletePosts.ViewModel) {
        let oldPosts = posts
        posts = viewModel.posts

        var indexPaths: [IndexPath] = []
        if let id = viewModel.id {
            if let postIndex = oldPosts.firstIndex(where: { $0.id == id }) {
                indexPaths = [IndexPath(row: postIndex, section: 0)]
            } else {
                return
            }
        } else {
            for i in 0..<oldPosts.count {
                let indexPath = IndexPath(row: i, section: 0)
                indexPaths.append(indexPath)
            }
        }

        postsTableView.deleteRows(at: indexPaths, with: .fade)
    }

    func displayFilteredPosts(viewModel: PostsList.FilterPosts.ViewModel) {
        posts = viewModel.posts
        postsTableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
    }

    // MARK: Private funcs
    private func configureSegmentedControl() {
        let textAttributesForNormalState = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let textAttributesForSelectedState = [NSAttributedString.Key.foregroundColor: UIColor.postsGreen]

        postsSegmentedControl.setTitleTextAttributes(textAttributesForSelectedState, for: .selected)
        postsSegmentedControl.setTitleTextAttributes(textAttributesForNormalState, for: .normal)
    }

    private func configureTableView() {
        postsTableView.dataSource = self
        postsTableView.delegate = self

        postsTableView.tableFooterView = UIView()
    }

}

// MARK: UITableViewDataSource
extension PostsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostListCell {
            cell.post = posts[indexPath.row]

            return cell
        }

        assert(false, "cell should be of PostListCell type")
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension PostsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            let request = PostsList.DeletePosts.Request(id: self.posts[indexPath.row].id)

            self.interactor?.delete(request: request)
            completionHandler(true)
        }

        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = UIColor.postsRed

        let configuration = UISwipeActionsConfiguration(actions: [action])

        return configuration
    }
}
