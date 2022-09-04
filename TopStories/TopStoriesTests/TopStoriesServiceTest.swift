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
        let client = HTTPClientSpy()
        _ = TopStoriesService(client: client, urlRequest: URLRequest(url: URL(string: "https://some-url.com")!))
        
        XCTAssert(client.requestedURL.isEmpty)
        
    }
    
    func test_fetch_requestDataFromClient() throws {
        let client = HTTPClientSpy()
        let sut = TopStoriesService(client: client, urlRequest: URLRequest(url: URL(string: "https://some-url.com")!))
        
        sut.fetch(completion: {_ in })
        
        XCTAssert(!client.requestedURL.isEmpty)
    }
    
    //MARK: - Helpers
    class HTTPClientSpy: HTTPClient {
        
        var requestedURL: [URLRequest] = []
        
        func perform(urlRequest: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            requestedURL.append(urlRequest)
        }
        
    }
    
}
