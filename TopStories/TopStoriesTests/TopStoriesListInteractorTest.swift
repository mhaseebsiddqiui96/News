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
    
    
    //MARK: - Helpers
   
    class TopStoriesServiceSpy: TopStoriesServiceProtocol {
     
        var capturedCompletions: [(Result<[StoryItem], TopStoryServiceError>) -> Void] = []
        func fetch(completion: @escaping (Result<[StoryItem], TopStoryServiceError>) -> Void) {
            self.capturedCompletions.append(completion)
        }
    }
}
