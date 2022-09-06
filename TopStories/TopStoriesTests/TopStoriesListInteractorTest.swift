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
        
       // XCTAssertEqual(service., <#T##expression2: Equatable##Equatable#>)
    }
    
    
    //MARK: - Helpers
   
    class TopStoriesServiceSpy: TopStoriesServiceProtocol {
        
        func fetch(completion: @escaping (Result<[StoryItem], TopStoryServiceError>) -> Void) {
            
        }
    }
}
