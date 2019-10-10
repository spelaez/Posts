//
//  PostsListViewControllerTests.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/9/19.
//  Copyright (c) 2019 Santiago Pelaez Rua. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import Posts
import XCTest

class PostsListViewControllerTests: XCTestCase {

    // MARK: Subject under test
    var sut: PostsListViewController!
    var businessLogicSpy: PostsListBusinessLogicSpy!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupPostsListViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    func setupPostsListViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = (storyboard.instantiateViewController(withIdentifier: "PostsListViewController") as! PostsListViewController)
        businessLogicSpy = PostsListBusinessLogicSpy()
        sut.interactor = businessLogicSpy
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    class PostsListBusinessLogicSpy: PostsListBusinessLogic {
        // MARK: method call expectations
        var fetchCalled = false
        var deleteCalled = false
        var deleteAllCalled = false
        var filterCalled = false
        var markAsReadCalled = false

        // MARK: Argument expectations
        var filter: PostsList.FilterPosts.Filter = .all

        // MARK: Spied methods
        func fetch(request: PostsList.FetchPosts.Request) {
            fetchCalled = true
        }

        func delete(request: PostsList.DeletePosts.Request) {
            deleteCalled = true
        }

        func deleteAll(request: PostsList.DeletePosts.Request) {
            deleteAllCalled = true
        }

        func filter(request: PostsList.FilterPosts.Request) {
            filterCalled = true
            filter = request.filter
        }

        func markPostAsRead(id: Int) {
            markAsReadCalled = true
        }
    }
    
    // MARK: Tests
    func testShouldFetchWhenViewIsLoaded() {
        // When
        loadView()

        // Then
        XCTAssertTrue(businessLogicSpy.fetchCalled, "Fetch should be called when the view is loaded")
    }
    
    func testShouldConfigureSegmentedControllWhenViewIsLoaded() {
        // Given
        let expectedTextColorForNormalState = UIColor.white
        let expectedTextColorSelectedState = UIColor.postsGreen
        
        // When
        loadView()
        
        // Then
        let textColorForNormalState = sut.postsSegmentedControl.titleTextAttributes(for: .normal)?[NSAttributedString.Key.foregroundColor] as? UIColor
        let textColorForSelectedState = sut.postsSegmentedControl.titleTextAttributes(for: .selected)?[NSAttributedString.Key.foregroundColor] as? UIColor

        XCTAssertEqual(textColorForNormalState, expectedTextColorForNormalState, "text color for normal state should be white")
        XCTAssertEqual(textColorForSelectedState, expectedTextColorSelectedState, "text color for selected state should be postsGreen")
    }

    func testShouldConfigurePostsTableViewWhenViewIsLoaded() {
        // Given

        // When
        loadView()

        // Then
        XCTAssertNotNil(sut.postsTableView.dataSource, "Posts table view dataSource should be set")
        XCTAssertNotNil(sut.postsTableView.delegate, "Posts table view delegate should be set")
        XCTAssertNotNil(sut.postsTableView.tableFooterView, "Posts table view tableFooterView should be set")
    }
    
    func testShouldDisplayPosts() {
        // Given
        let post = Post(userId: 1,
                                  id: 1,
                                  title: "post title",
                                  body: "post body",
                                  isFavorite: false,
                                  isUnread: true)

        let viewModel = PostsList.FetchPosts.ViewModel(posts: [post])
        
        // When
        loadView()
        sut.displayPosts(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.postsTableView.numberOfRows(inSection: 0), viewModel.posts.count, "number of posts should match viewModel posts")

        let sutPost = sut.posts[0]

        XCTAssertEqual(sutPost.id, post.id, "posts have different ids")
        XCTAssertEqual(sutPost.userId, post.userId, "posts have different userIds")
        XCTAssertEqual(sutPost.title, post.title, "posts have different titles")
        XCTAssertEqual(sutPost.body, post.body, "posts have different bodies")
        XCTAssertEqual(sutPost.isFavorite, sutPost.isFavorite, "posts have different favorite value")
        XCTAssertEqual(sutPost.isUnread, sutPost.isUnread, "posts have different read status")
    }

    func testShouldCallDelete() {
        // Given
        let post = Post(userId: 1,
                                  id: 1,
                                  title: "post title",
                                  body: "post body",
                                  isFavorite: false,
                                  isUnread: true)

        sut.posts = [post]

        // When
        loadView()

        let swipeActions = sut.tableView(sut.postsTableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))

        guard let deleteAction = swipeActions?.actions.first else {
            XCTFail("couldn't get an action from cell's trailing swipe actions")
            return
        }

        // Then
        deleteAction.handler(deleteAction, UIView()) { deleteCalled in
            XCTAssertTrue(deleteCalled, "deleteAction handler should be called")
        }

        XCTAssertTrue(businessLogicSpy.deleteCalled, "viewController should ask interactor to delete the post")
    }

    func testShouldCallDeleteAllOnInteractor() {
        // When
        loadView()
        sut.deleteAllPosts(self)

        // Then
        XCTAssertTrue(businessLogicSpy.deleteAllCalled, "viewController should ask interactor to delete the post")
    }

    func testShouldDisplayPostsAfterDelete() {
        // Given
        let post = Post(userId: 1,
                                  id: 1,
                                  title: "post title",
                                  body: "post body",
                                  isFavorite: false,
                                  isUnread: true)

        let viewModel = PostsList.DeletePosts.ViewModel(id: 1, posts: [post])

        // When
        sut.posts = [post, post]
        loadView()

        sut.displayPosts(viewModel: viewModel)

        // Then
        XCTAssertEqual(sut.postsTableView.numberOfRows(inSection: 0), viewModel.posts.count, "number of posts should match viewModel posts")
    }

    func testShouldDisplayPostsOnReloadPosts() {
        // When
        loadView()
        businessLogicSpy.fetchCalled = false
        sut.reloadPosts(self)

        // Then
        XCTAssertTrue(businessLogicSpy.fetchCalled, "Fetch should be called when the view is loaded")
    }

    func testShouldNotDisplayPostsAfterDeleteAll() {
        // Given
        let post = Post(userId: 1,
                                  id: 1,
                                  title: "post title",
                                  body: "post body",
                                  isFavorite: false,
                                  isUnread: true)

        let viewModel = PostsList.DeletePosts.ViewModel(posts: [])

        // When
        sut.posts = [post, post]
        loadView()
        sut.displayPosts(viewModel: viewModel)

        // Then
        XCTAssertEqual(sut.postsTableView.numberOfRows(inSection: 0), viewModel.posts.count, "number of posts should match viewModel posts")
    }

    func testShouldAskInteractorToFilterFavoritePosts() {
        //When
        loadView()
        sut.postsSegmentedControl.selectedSegmentIndex = 1
        sut.postsSegmentedControlDidChange(sut.postsSegmentedControl)

        //Then
        XCTAssertTrue(businessLogicSpy.filterCalled, "viewcontroller should ask interactor to filter posts")
        XCTAssertEqual(businessLogicSpy.filter, PostsList.FilterPosts.Filter.favorites, "filter should be favorites")
    }

    // MARK: Cell Tests
    func testCellWithUnreadPostShouldHaveBlueDotAndPostTitle() {
        // Given
        let post = Post(userId: 1,
                                  id: 1,
                                  title: "post title",
                                  body: "post body",
                                  isFavorite: false,
                                  isUnread: true)

        // When
        loadView()
        sut.posts = [post]
        sut.postsTableView.reloadData()
        let cell = sut.tableView(sut.postsTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? PostListCell

        XCTAssertEqual(cell?.accessoryImage.tintColor, UIColor.postsBlue, "the tint color of cell's image should be postsBlue")
        XCTAssertEqual(cell?.accessoryImage.image, UIImage(systemName: "circle.fill"), "the cell's image should be circle.fill")
        XCTAssertEqual(cell?.titleLabel.text, post.title, "the cell's title doesn't match post's title")
    }

    func testCellWithFavoritePostShouldHaveBlueDotAndPostTitle() {
        // Given
        let post = Post(userId: 1,
                                  id: 1,
                                  title: "post title",
                                  body: "post body",
                                  isFavorite: true,
                                  isUnread: false)

        // When
        loadView()
        sut.posts = [post]
        sut.postsTableView.reloadData()

        let cell = sut.tableView(sut.postsTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? PostListCell

        XCTAssertEqual(cell?.accessoryImage.tintColor, UIColor.postsYellow, "the tint color of cell's image should be postsBlue")
        XCTAssertEqual(cell?.accessoryImage.image, UIImage(systemName: "star.fill"), "the cell's image should be circle.fill")
        XCTAssertEqual(cell?.titleLabel.text, post.title, "the cell's title doesn't match post's title")
    }

    func testCellWithPostReadAndNoFavoriteShouldNotHaveImage() {
        // Given
        let post = Post(userId: 1,
                        id: 1,
                        title: "",
                        body: "",
                        isFavorite: false,
                        isUnread: false)
        // When
        loadView()
        sut.posts = [post]
        sut.postsTableView.reloadData()

        let cell = sut.tableView(sut.postsTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? PostListCell

        XCTAssertNil(cell?.accessoryImage.image, "a read post should not have image")
    }
}
