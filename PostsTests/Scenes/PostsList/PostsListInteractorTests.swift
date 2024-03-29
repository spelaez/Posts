//
//  PostsListInteractorTests.swift
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

class PostsListInteractorTests: XCTestCase {
    // MARK: Subject under test
    var sut: PostsListInteractor!
    
    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        setupPostsListInteractor()
    }
    
    // MARK: Test setup
    func setupPostsListInteractor() {
        sut = PostsListInteractor()
    }
    
    // MARK: Test doubles
    class PostsListPresentationLogicSpy: PostsListPresentationLogic {
        var presentFilteredPostsCalled = false
        var presentPostsCalled = false

        var fetchResponse: PostsList.FetchPosts.Response!
        var deleteResponse: PostsList.DeletePost.Response!
        var filterResponse: PostsList.FilterPosts.Response!

        func presentPosts(response: PostsList.FetchPosts.Response) {
            presentPostsCalled = true
            self.fetchResponse = response
        }

        func presentPosts(response: PostsList.DeletePost.Response) {
            presentPostsCalled = true
            self.deleteResponse = response
        }

        func presentPosts(response: PostsList.DeleteAllPosts.Response) {
            presentPostsCalled = true
        }

        func presentFilteredPosts(response: PostsList.FilterPosts.Response) {
            presentFilteredPostsCalled = true
            self.filterResponse = response
        }
    }

    class PostsListWorkerSpy: PostsListWorker {
        var fetchPostsCalled = false
        var deletePostCalled = false
        var deleteAllPostsCalled = false
        var postsFilteredByCalled = false

        var mockPosts: [Post] {
            var posts = [Post]()

            for i in 1...21 {
                let post = Post(userId: i, id: i, title: "", body: "")
                posts.append(post)
            }

            return posts
        }

        override func fetchPosts(completionHandler: @escaping (([Post]) -> ())) {
            fetchPostsCalled = true
            completionHandler(mockPosts)
        }


        override func deletePost(post: Post) {
            deletePostCalled = true
        }

        override func deleteAllPosts() {
            deleteAllPostsCalled = true
        }

        override func filter(posts: [Post], by filter: PostsList.FilterPosts.Filter) -> [Post] {
            postsFilteredByCalled = true
            return posts.filter { $0.isFavorite }
        }
    }
    
    // MARK: Tests
    func testFetchShouldAskPostsListWorkerToFetchPostsAndPresenterToFormatThem() {
        // Given
        let postsListPresentationLogicSpy = PostsListPresentationLogicSpy()
        let postsListWorkerSpy = PostsListWorkerSpy()

        sut.worker = postsListWorkerSpy
        sut.presenter = postsListPresentationLogicSpy

        // When
        let request = PostsList.FetchPosts.Request()
        sut.fetch(request: request)

        // Then
        XCTAssertTrue(postsListWorkerSpy.fetchPostsCalled, "fetch() should ask worker to fetch posts")
        XCTAssertTrue(postsListPresentationLogicSpy.presentPostsCalled, "fetch() should ask presenter to format posts")
    }

    func testDeleteShouldAskPostListWorkerToDeletePostAndPresenterToFormatResponse() {
        //Given
        let postsListPresentationLogicSpy = PostsListPresentationLogicSpy()
        let postsListWorkerSpy = PostsListWorkerSpy()

        sut.worker = postsListWorkerSpy
        sut.presenter = postsListPresentationLogicSpy

        // When
        let request = PostsList.DeletePost.Request(post: Post(userId: 1, id: 1, title: "", body: ""))
        sut.delete(request: request)

        // Then
        XCTAssertTrue(postsListWorkerSpy.deletePostCalled, "delete() should ask worker to delete posts")
        XCTAssertTrue(postsListPresentationLogicSpy.presentPostsCalled, "delete() should ask presenter to format response")
    }

    func testFilterShouldAskPostsListWorkerToFilterPostsAndPresenterToFormatResponse() {
        //Given
        let postsListPresentationLogicSpy = PostsListPresentationLogicSpy()
        let postsListWorkerSpy = PostsListWorkerSpy()

        sut.worker = postsListWorkerSpy
        sut.posts = [Post(userId: 1, id: 1, title: "", body: "", isFavorite: true, isUnread: false),
                             Post(userId: 1, id: 2, title: "", body: "", isFavorite: false, isUnread: false)]

        sut.presenter = postsListPresentationLogicSpy

        // When
        let request = PostsList.FilterPosts.Request(filter: .favorites)
        sut.filter(request: request)

        // Then
        XCTAssertTrue(postsListWorkerSpy.postsFilteredByCalled, "filter() should ask worker to filter posts")
        XCTAssertTrue(postsListPresentationLogicSpy.presentFilteredPostsCalled, "filter() should ask presenter to format response")
    }

    func testInteractorShouldAskWorkerToDeleteAllPosts() {
        // Given
        let workerSpy = PostsListWorkerSpy()
        sut.worker = workerSpy

        // When
        sut.deleteAll(request: PostsList.DeleteAllPosts.Request())

        // Then
        XCTAssertTrue(workerSpy.deleteAllPostsCalled, "interactor should call deleteAllPosts on worker")
    }
}
