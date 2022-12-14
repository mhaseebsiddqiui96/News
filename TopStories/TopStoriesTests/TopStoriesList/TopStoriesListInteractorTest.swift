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
    
    func test_getTopStories_notifiesPresenterWithConectivityError_whenReceivesConnectivityErrorFromSerivce() throws {
        let (sut, presenter, service) = makeSUT()
        
        sut.getTopStoriesList(for: "Home")
        service.complete(with: .failure(.internetConnectivity))
        
        XCTAssertEqual(presenter.receievedError, [.internetConnectivity])
    }
    
    func test_getTopStories_notifiesPresenterWithInvalidDataError_whenReceivesInvalidDataErrorFromSerivce() throws {
        let (sut, presenter, service) = makeSUT()

        
        sut.getTopStoriesList(for: "Home")
        service.complete(with: .failure(.invalidData))
        
        XCTAssertEqual(presenter.receievedError, [.invalidData])
    }
    
    
    func test_getTopStories_notifiesPresenterWithAuthError_whenReceivesAuthErrorFromSerivce() throws {
        let (sut, presenter, service) = makeSUT()

        sut.getTopStoriesList(for: "Home")
        service.complete(with: .failure(.unAuthorized))
        
        XCTAssertEqual(presenter.receievedError, [.unAuthorized])
    }
    
    
    func test_getTopStories_notifiesPresenterWithTopNews_whenReceivesNewsFromSerivce() throws {
        let (sut, presenter, service) = makeSUT()
        
        let expectedStories = [
            StoryItem(id: UUID(), title: nil, abstract: nil, url: nil, byline: nil, multimedia: nil),
            
            StoryItem(id: UUID(), title: nil, abstract: nil, url: nil, byline: nil, multimedia: nil)
        ]
        sut.presenter = presenter
        
        sut.getTopStoriesList(for: "Home")
        service.complete(with: .success(expectedStories))
        
        XCTAssertEqual(presenter.receivedStories, expectedStories)
    }
    
    
    //MARK: - Helpers
   
    class TopStoriesServiceSpy: TopStoriesServiceProtocol {
        
        var capturedCompletions: [(Result<[StoryItem], TopStoryServiceError>) -> Void] = []
        
        func fetch(urlRequest: URLRequest, completion: @escaping (Result<[StoryItem], TopStoryServiceError>) -> Void) {
            self.capturedCompletions.append(completion)
        }
        
        func complete(with result: Result<[StoryItem], TopStoryServiceError>) {
            self.capturedCompletions[0](result)
        }
    }
    
    class PresenterSpy: TopStoriesListInteractorOutputProtocol {
        var receievedError = [TopStoryServiceError]()

        var receivedStories = [StoryItem]()
        
        func presentListOfStories(_ stories: [StoryItem]) {
            receivedStories = stories
        }
        
        func presentError(_ error: TopStoryServiceError) {
            receievedError.append(error)
        }
    }
    
    func makeSUT() -> (TopStoriesListInteractor, PresenterSpy, TopStoriesServiceSpy) {
        let service = TopStoriesServiceSpy()
        let presenter = PresenterSpy()
        let sut = TopStoriesListInteractor(service: service)
        sut.presenter = presenter
        return (sut, presenter, service)
    }
    
}


