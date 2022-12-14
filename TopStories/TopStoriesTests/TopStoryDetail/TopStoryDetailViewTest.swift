//
//  TopStoryDetailViewTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/9/22.
//

import XCTest
@testable import TopStories

class TopStoryDetailViewTest: XCTestCase {

    func test_buttonTapp_callsSeeMoreTappedClosue() throws {
        let view = TopStoryDetailView()
        
        var closureCalled = false
        view.seeMoreTapped = {
            closureCalled = true
        }
        
        view.seeMoreButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(closureCalled, true)
    }
    
    func test_displayStoryDetails_updateUI() throws {
        let view = TopStoryDetailView()
        view.displayStoryDetails(StoryDetailViewModel(title: "Haseeb", author: "SomeOne", description: "Hello work", url: URL(string: "https://some-url.com")!, imgData: Data(), completeStoryURL: nil))
        
        let expectation = expectation(description: "Test")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1, handler: nil)
        
        
        XCTAssertEqual(view.storyAuthorLabel.text, "SomeOne")
        XCTAssertEqual(view.storyTitleLabel.text, "Haseeb")
        XCTAssertEqual(view.storyAbstactLabel.text, "Hello work")
        
    }

}
