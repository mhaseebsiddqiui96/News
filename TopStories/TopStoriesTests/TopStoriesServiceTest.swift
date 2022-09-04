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
        XCTAssert(client.requestedURLs.isEmpty)
        
    }
    
    func test_fetch_requestDataFromClient() throws {
        
        let url = URL(string: "https://test1.com")!
        let (client, sut) = makeSUT(url: url)
        
        sut.fetch(completion: {_ in })
        
        XCTAssertEqual(client.requestedURLs.first?.url, url)
    }
    

    func test_fetchOnce_requestDataFromClientOnce() throws {
        
        let url = URL(string: "https://test1.com")!
        let (client, sut) = makeSUT(url: url)
        
        sut.fetch(completion: {_ in })
        
        XCTAssertEqual(client.requestURLsCount, 1)
    }
    
    func test_fetchTwice_requestDataFromClientTwice() throws {
        
        let url = URL(string: "https://test1.com")!
        let (client, sut) = makeSUT(url: url)
        
        sut.fetch(completion: {_ in })
        sut.fetch(completion: {_ in })
        
        XCTAssertEqual(client.requestURLsCount, 2)
    }
    
    func test_fetch_deliversErrorOnClientError() throws {
        let (client, sut) = makeSUT()
        var receivedError: [TopStoriesService.Error] = []
        sut.fetch { response in
            switch response {
            case .success:
                break
            case .failure(let err):
                receivedError.append(err)
            }
        }
        
        client.responseCompletions.first?(.failure(NSError(domain: "domain", code: 400)))
        XCTAssertEqual(receivedError, [.internetConnectivity])
        
    }
    
    //MARK: - Helpers
    class HTTPClientSpy: HTTPClient {
        
        var requestedURLs: [URLRequest] = []
        var requestURLsCount: Int {
            return requestedURLs.count
        }
        var responseCompletions: [(HTTPClientResult) -> Void] = []
        
        func perform(urlRequest: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            requestedURLs.append(urlRequest)
            responseCompletions.append(completion)
        }
        
    }
    
    // factory method to create sut. it will help if the creation of changes then we only need to update this method rest of the test will not be effected
    func makeSUT(url: URL = URL(string: "https://some-url.com")!) -> (client: HTTPClientSpy, service: TopStoriesService) {
        let client = HTTPClientSpy()
        let sut = TopStoriesService(client: client, urlRequest: URLRequest(url: url))
        
        return (client, sut)
    }
    
}
