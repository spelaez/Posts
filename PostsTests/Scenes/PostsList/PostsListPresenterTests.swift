//
//  PostsListPresenterTests.swift
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

class PostsListPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: PostsListPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPostsListPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPostsListPresenter() {
        sut = PostsListPresenter()
    }
    
    // MARK: Test doubles
    
    class PostsListDisplayLogicSpy: PostsListDisplayLogic {
        var displaySomethingCalled = false
        
        func displaySomething(viewModel: PostsList.Something.ViewModel) {
            displaySomethingCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentSomething() {
        // Given
        let spy = PostsListDisplayLogicSpy()
        sut.viewController = spy
        let response = PostsList.Something.Response()
        
        // When
        sut.presentSomething(response: response)
        
        // Then
        XCTAssertTrue(spy.displaySomethingCalled, "presentSomething(response:) should ask the view controller to display the result")
    }
}
