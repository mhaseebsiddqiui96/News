//
//  TopStoryDetailInteractorTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import XCTest
@testable import TopStories

class TopStoryDetailInteractorTest: XCTestCase {
    
    func test_getTopStoryDetail_notifiesPresenterWithDetail() throws {
        
        let entity = StoryItem(id: UUID(), section: "section1", subsection: "subsection1", title: "title1", abstract: "abstract1", url: "https://some-url.com", uri: nil, byline: "by haseeb", itemType: nil, updatedDate: Date(), createdDate: Date(), publishedDate: Date(), multimedia: nil)
        
        let sut = TopStoryDetailInteractor(entity)
        let presenter = PresenterSpy()
        sut.presenter = presenter
        
        sut.getTopStoryDetail()
        
        XCTAssertEqual(presenter.presentDetails, [entity])
        
    }
    
    
    //MARK: - Helpers
    class PresenterSpy: TopStoryDetailInteractorOutputProtocol {
        
        var presentDetails = [StoryItem]()
        
        func presentStoryDetails(_ entity: StoryItem) {
            presentDetails.append(entity)
        }
        
    }

}
