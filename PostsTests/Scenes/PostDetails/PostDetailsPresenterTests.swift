//
//  PostDetailsPresenterTests.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/10/19.
//  Copyright (c) 2019 Santiago Pelaez Rua. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import Posts
import XCTest

class PostDetailsPresenterTests: XCTestCase {
    // MARK: Subject under test
    var sut: PostDetailsPresenter!
    
    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        setupPostDetailsPresenter()
    }
    
    // MARK: Test setup
    func setupPostDetailsPresenter() {
        sut = PostDetailsPresenter()
    }
    
    // MARK: Test doubles
    class PostDetailsDisplayLogicSpy: PostDetailsDisplayLogic {
        // MARK: method call expectations
        var displayPostCalled = false
        var displayUpdatePostsList = false
        var displayToggleFavorite = false
        var displayCommentsCalled = false

        // MARK: argument expectations
        var getPostViewModel: PostDetails.GetPost.ViewModel!

        func displayPost(viewModel: PostDetails.GetPost.ViewModel) {
            displayPostCalled = true
            getPostViewModel = viewModel
        }

        func displayUpdatePostsList(viewModel: PostDetails.UpdatePostsList.ViewModel) {
            displayUpdatePostsList = true
        }

        func displayToggleFavorite(viewModel: PostDetails.ToggleFavorite.ViewModel) {
            displayToggleFavorite = true
        }

        func displayComments(viewModel: PostDetails.GetComments.ViewModel) {
            displayCommentsCalled = true
        }
    }
    
    // MARK: Tests
    func testPresenterShouldAskViewControllerToDisplayPost() {
        // Given
        let displayLogicSpy = PostDetailsDisplayLogicSpy()

        sut.viewController = displayLogicSpy

        // When
        let post = Post(userId: 1, id: 1, title: "", body: "post body")
        let user = User(name: "Jhon Doe", email: "jd@mail.com", phone: "123", website: "jd.com")
        let response = PostDetails.GetPost.Response(post: post, user: user)

        sut.presentPost(response: response)

        // Then
        XCTAssertTrue(displayLogicSpy.displayPostCalled, "presenter should call display post on viewController")
        XCTAssertEqual(displayLogicSpy.getPostViewModel.displayedPost.body, post.body, "presenter should send the same post body to viewController in response")
        XCTAssertEqual(displayLogicSpy.getPostViewModel.user.name, user.name)
        XCTAssertEqual(displayLogicSpy.getPostViewModel.user.email, user.email)
        XCTAssertEqual(displayLogicSpy.getPostViewModel.user.phone, user.phone)
        XCTAssertEqual(displayLogicSpy.getPostViewModel.user.website, user.website)
    }
}
