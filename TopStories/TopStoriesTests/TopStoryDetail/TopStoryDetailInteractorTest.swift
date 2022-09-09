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
        
        let entity = StoryItem(id: UUID(), section: "section1", subsection: "subsection1", title: "title1", abstract: "abstract1", url: "https://some-url.com", uri: nil, byline: "by haseeb", itemType: nil, multimedia: nil)
        
        let sut = TopStoryDetailInteractor(entity, service: SeriveSpy())
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
        
        func presentImageData(_ data: Data) {
            
        }
        
    }
    
    class SeriveSpy: ImageLoaderSerivceProtocol {
        func loadImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
            return nil
        }
        
    }

}
