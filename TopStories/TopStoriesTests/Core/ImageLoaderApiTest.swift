//
//  ImageLoaderApiTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import XCTest
@testable import TopStories

class ImageLoaderApiTest: XCTestCase {


    func test_loadImageData_requestClientWithURL() throws {
        let client = HTTPClientSpy()
        let sut = ImageLoaderSerivce(client: client)
        sut.loadImageData(with: URL(string: "https://some-url.com")!, completion: { result in
            
        })
        
        XCTAssert(client.requestedURLs == [URLRequest(url: URL(string: "https://some-url.com")!)])
    }
    
    func test_loadImageData_deliversDataWithValidDataFromClient() throws {
        
        let client = HTTPClientSpy()
        let sut = ImageLoaderSerivce(client: client)
        var recievedResult: Data?
        sut.loadImageData(with: URL(string: "https://some-url.com")!, completion: { result in
            switch result {
            case .success(let data):
                recievedResult = data
            case .failure:
                XCTFail("Expected Success but found failure")
            }
        })
        
        let anyData = Data()
        client.success(with: 200, and: anyData, at: 0)
        
        XCTAssertEqual(anyData, recievedResult)
    }
    
    func test_loadImageData_deliversErrorOnClientError() throws {
        
        let client = HTTPClientSpy()
        let sut = ImageLoaderSerivce(client: client)
        var recievedResult: NSError?
        sut.loadImageData(with: URL(string: "https://some-url.com")!, completion: { result in
            switch result {
            case .success:
                XCTFail("Expected failure but found success")
            case .failure(let error as NSError):
                recievedResult = error
            }
        })
        
        let anyError = NSError(domain: "domain", code: 1)
        client.fail(with: anyError)
        
        XCTAssertEqual(anyError.code, recievedResult?.code)
        XCTAssertEqual(anyError.domain, recievedResult?.domain)

    }
}
