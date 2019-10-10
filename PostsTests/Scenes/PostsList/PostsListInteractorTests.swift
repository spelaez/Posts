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
        var presentPostsCalled = false

        func presentPosts(response: PostsList.FetchPosts.Response) {
            presentPostsCalled = true
        }
    }

    class PostsListWorkerSpy: PostsListWorker {
        var fetchPostsCalled = false

        override func fetchPosts() -> [PostsList.Post] {
            fetchPostsCalled = true
            return []
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
}