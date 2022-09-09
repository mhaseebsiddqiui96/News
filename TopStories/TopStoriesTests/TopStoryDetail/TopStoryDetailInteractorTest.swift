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
        
        let entity = StoryItem(id: UUID(), title: "title1", abstract: "abstract1", url: "https://some-url.com", byline: "by haseeb", multimedia: [StoryItem.Multimedia(url: "https://some-url.com", format: .superJumbo)])
        
        let (service, presenter, sut) = makeSUT(entity: entity)
        
        sut.getTopStoryDetail()
        
        XCTAssertEqual(presenter.presentDetails, [entity])
        XCTAssertEqual(presenter.presentImage, [])
        
        let anyData = Data()
        service.requests[URL(string: "https://some-url.com")!]?(.success(anyData))
        
        XCTAssertEqual(presenter.presentImage, [anyData])
    }

    //MARK: - Helpers
    class PresenterSpy: TopStoryDetailInteractorOutputProtocol {
        
        var presentDetails = [StoryItem]()
        var presentImage = [Data]()
        
        func presentStoryDetails(_ entity: StoryItem) {
            presentDetails.append(entity)
        }
        
        func presentImageData(_ data: Data) {
            presentImage.append(data)
        }
        
    }
    
    class SeriveSpy: ImageLoaderSerivceProtocol {
        var requests = [URL: (Result<Data, Error>) -> Void]()
        
        func loadImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
            requests[url] = completion
            return nil
            
        }
        
    }

    func makeSUT(entity: StoryItem) -> (SeriveSpy,PresenterSpy, TopStoryDetailInteractor) {
      
        
        let service = SeriveSpy()
        let sut = TopStoryDetailInteractor(entity, service: service)
        let presenter = PresenterSpy()
        sut.presenter = presenter
        
        return (service, presenter, sut)
    }
}
