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

        let url = URL(string: "https://any-url.com")!
        let requestError = NSError(domain: "some-domeain", code: 1)
        //stubbing
        let receivedError = getErrorFromHTTPResult(error: requestError, data: nil, response: nil, for: url) as? NSError
        
        XCTAssertEqual(receivedError?.code, requestError.code)
        XCTAssertEqual(receivedError?.domain, requestError.domain)
       
    }
    
    func test_perform_deliversFailureWithAnyErrorOnAllValuesNil() throws {
        let url = URL(string: "https://any-url.com")!
        let receivedError = getErrorFromHTTPResult(error: nil, data: nil, response: nil, for: url) as? NSError
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_perform_deliversFailureWithAnyErrorOnAllValuesFilled() throws {
        let url = URL(string: "https://any-url.com")!
        let expectedError = NSError(domain: "some-domeain", code: 1)
        let expectedData = Data()
        let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let receivedError = getErrorFromHTTPResult(error: expectedError, data: expectedData, response: expectedResponse, for: url) as? NSError
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_perform_deliversSuccessOnDataAndResponse() throws {
        
        let url = URL(string: "https://any-url.com")!
        let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let expectedData = Data()
        
        if let response = getResponseFromSession(error: nil, data: expectedData, response: expectedResponse, for: url) {
            switch response {
                
            case .success((let data, let response)):
                XCTAssertEqual(data, expectedData)
                XCTAssertEqual(expectedResponse?.statusCode, response.statusCode)
            case .failure(let error):
                XCTFail("Expected Sucess but found error: \(error)")
            }
        }
        
    }
    
    //Can create one more test in which we can test different cases of Error
    
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
            
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let err = stub.error {
                client?.urlProtocol(self, didFailWithError: err)
            }
            
            client?.urlProtocolDidFinishLoading(self)
            
            
        }
        
        override func stopLoading() {
            
        }
        
        static func stub(error: Error?, data: Data?, response: URLResponse?, for URL: URL) {
            URLProtocolStub.stubsForURLs[URL] = Stub(error: error, data: data, response: response)
        }
    }
    
    func getResponseFromSession(error: Error?, data: Data?, response: URLResponse?, for url: URL) -> HTTPClientResult? {
        
        URLProtocol.registerClass(URLProtocolStub.self)
        URLProtocolStub.stub(error: error, data: data, response: response, for: url)

        let sut = URLSessionClient()
        let urlRequest = URLRequest(url: url)
        var expectedHttpClientResult: HTTPClientResult?
        
        let expectation = expectation(description: "Wait for perform to finish")
        
        sut.perform(urlRequest: urlRequest) { result in
            expectedHttpClientResult = result
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        URLProtocol.unregisterClass(URLProtocolStub.self)
        return expectedHttpClientResult
    }
    
    func getErrorFromHTTPResult(error: Error?, data: Data?, response: URLResponse?, for url: URL, line: UInt = #line, file: StaticString = #filePath) -> Error? {
        
        if let response = getResponseFromSession(error: error, data: data, response: response, for: url) {
            switch response {
                
            case .success((_, let response)):
                XCTFail("Expected Error but found Success: \(response)", file: file, line: line)
                return nil
            case .failure(let error):
                return error
            }
        }
        
        XCTFail("didn't get any resposne", file: file, line: line)
        return nil
    }
    
}
