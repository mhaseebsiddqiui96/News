//
//  TopStoriesListInteractorTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/6/22.
//

import XCTest
@testable import TopStories

class TopStoriesListInteractorTest: XCTestCase {

    func test_getTopStories_callsServiceForData() throws {
        let service = TopStoriesServiceSpy()
        let sut = TopStoriesListInteractor(service: service)
        
        sut.getTopStoriesList(for: "Home")
        
        XCTAssertEqual(service.capturedCompletions.count, 1)
    }
    
    func test_getTopStories_notifiesPresenterConectivityError() throws {
        let service = TopStoriesServiceSpy()
        let presenter = PresenterSpy()
        let sut = TopStoriesListInteractor(service: service)
        sut.presenter = presenter
        
        sut.getTopStoriesList(for: "Home")
        service.complete(with: .failure(.internetConnectivity))
        
        XCTAssertEqual(presenter.connectivityErrorCount, 1)
    }
    
    
    //MARK: - Helpers
   
    class TopStoriesServiceSpy: TopStoriesServiceProtocol {
     
        var capturedCompletions: [(Result<[StoryItem], TopStoryServiceError>) -> Void] = []
        
        func fetch(completion: @escaping (Result<[StoryItem], TopStoryServiceError>) -> Void) {
            self.capturedCompletions.append(completion)
        }
        
        func complete(with result: Result<[StoryItem], TopStoryServiceError>) {
            self.capturedCompletions[0](result)
        }
    }
    
    class PresenterSpy: TopStoriesListInteractorOutputProtocol {
        var connectivityErrorCount = 0
        
        func presentListOfStories(_ stories: [StoryItem]) {
            
        }
        
        func presentConnectivityError() {
            connectivityErrorCount += 1
        }
        
    }
}
