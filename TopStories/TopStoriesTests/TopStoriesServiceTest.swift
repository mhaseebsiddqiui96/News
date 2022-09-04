//
//  TopStoriesTests.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/4/22.
//

import XCTest
@testable import TopStories

class TopStoriesServiceTest: XCTestCase {
    

    func test_init_doesNotRequestDataFromClient() throws {
        
        let (client, _) = makeSUT()
        XCTAssert(client.requestedURL.isEmpty)
        
    }
    
    func test_fetch_requestDataFromClient() throws {
        
        let url = URL(string: "https://test1.com")!
        let (client, sut) = makeSUT(url: url)
        
        sut.fetch(completion: {_ in })
        
        XCTAssertEqual(client.requestedURL.first?.url, url)
    }
    
    
    //MARK: - Helpers
    class HTTPClientSpy: HTTPClient {
        
        var requestedURL: [URLRequest] = []
        
        func perform(urlRequest: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            requestedURL.append(urlRequest)
        }
        
    }
    
    // factory method to create sut. it will help if the creation of changes then we only need to update this method rest of the test will not be effected
    func makeSUT(url: URL = URL(string: "https://some-url.com")!) -> (client: HTTPClientSpy, service: TopStoriesService) {
        let client = HTTPClientSpy()
        let sut = TopStoriesService(client: client, urlRequest: URLRequest(url: url))
        
        return (client, sut)
    }
    
}
