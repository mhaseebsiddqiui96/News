//
//  URLSessionClientTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/5/22.
//

import XCTest
@testable import TopStories

class URLSessionClientTest: XCTestCase {


    func test_perform_deliversFailureOnRequestError() throws {

        URLProtocol.registerClass(URLProtocolStub.self)
       
        let sut = URLSessionClient()
        let url = URL(string: "https://some-url.com")!
        let request = URLRequest(url: url)
        let error = NSError(domain: "some-domeain", code: 1)
        
        //stubbing
        URLProtocolStub.stub(with: error, for: url)
        let exp = expectation(description: "wait for the error to come")
        sut.perform(urlRequest: request) { result in
            switch result {
                
            case .success((_, _)):
                XCTFail("Expected Error but found success")
            case .failure(let receivedError as NSError):
                XCTAssertEqual(error.code, receivedError.code)
                XCTAssertEqual(error.domain, receivedError.domain)

            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocol.unregisterClass(URLProtocolStub.self)
        
    }
    
    //MARK: - Helpers
    
    class URLProtocolStub: URLProtocol {
        
        static private  var stubsForURLs: [URL: Stub] = [:]
        
        private struct Stub {
            let error: Error?
            let data: Data?
            let response: URLResponse?
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true // we intercept the request and handle it
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let url = request.url, let stub = URLProtocolStub.stubsForURLs[url]  else { fatalError() }
            
            if let err = stub.error {
                client?.urlProtocol(self, didFailWithError: err)
            }
        }
        
        override func stopLoading() {
            
        }
        
        static func stub(with error: Error, for URL: URL) {
            URLProtocolStub.stubsForURLs[URL] = Stub(error: error, data: nil, response: nil)
        }
    }
    
}
