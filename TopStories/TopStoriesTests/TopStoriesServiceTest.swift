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
   
        expect(sut, toCompleteWith: .failure(.internetConnectivity)) {
            let responseError = NSError(domain: "", code: 0)
            client.fail(with: responseError)
        }
    }
    
    func test_fetch_deliversErrorOnNon200StatusCode() throws {
        
        let (client, sut) = makeSUT()
        let sampleErrorCodes = [300, 400, 500, 405]
        
        sampleErrorCodes.enumerated().forEach({ index, code in
            
            let model1JSON = StoryItem(id: UUID(), section: "Home", subsection: "Home-inner", title: "Covid", abstract: nil, url: nil, uri: nil, byline: nil, itemType: "itemType1", updatedDateString: nil, createdDateString: nil, publishedDateString: nil, materialTypeFacet: nil, kicker: nil, desFacet: nil, orgFacet: [], perFacet: [], geoFacet: [], multimedia: [], shortURL: nil).makeJSON()
            
            let data = try! JSONSerialization.data(withJSONObject: model1JSON)
            
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                client.success(with: code, and: data, at: index)
            }
        })
       
    }
    
    func test_fetch_deliversUnAuthorizeErrorOn401StatusCode() throws {
        
        let (client, sut) = makeSUT()
   
        expect(sut, toCompleteWith: .failure(.unAuthorized)) {
            client.success(with: 401)
        }
    }
    
    func test_fetch_deliversErrorOn200WithInvalidJSON() throws {
        let (client, sut) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            client.success(with: 200, and: Data("invalid".utf8))
        }
    }
    
    func test_fetch_deliversEmptyStoriesOn200StatusWithValidEmptyResultJSON() throws {
        let (client, sut) = makeSUT()
        expect(sut, toCompleteWith: .success([])) {
            let validEmptyResultListJSON = Data("{\"results\": []}".utf8)
            client.success(with: 200, and: validEmptyResultListJSON)
        }
    }
    
    func test_fetch_deliversListOfStoriesOn200StatusCodeWithValidJSON() throws {
        let (client, sut) = makeSUT()
        
        let model1 = StoryItem(id: UUID(), section: "Home", subsection: "Home-inner", title: "Covid", abstract: nil, url: nil, uri: nil, byline: nil, itemType: "itemType1", updatedDateString: nil, createdDateString: nil, publishedDateString: nil, materialTypeFacet: nil, kicker: nil, desFacet: nil, orgFacet: [], perFacet: [], geoFacet: [], multimedia: [], shortURL: nil)
        let model1JSON = model1.makeJSON()
        
        let model2 = StoryItem(id: UUID(), section: "News", subsection: "News-inner", title: "Covid", abstract: nil, url: nil, uri: nil, byline: nil, itemType: "itemType2", updatedDateString: nil, createdDateString: nil, publishedDateString: nil, materialTypeFacet: nil, kicker: nil, desFacet: nil, orgFacet: [], perFacet: [], geoFacet: [], multimedia: [], shortURL: nil)
        let model2JSON = model2.makeJSON()
        
        expect(sut, toCompleteWith: .success([model1, model2])) {
            let json = ["results": [model1JSON, model2JSON]]
            let validResultListJSON = try! JSONSerialization.data(withJSONObject: json)
            client.success(with: 200, and: validResultListJSON)
        }
    }
    
    
    // MARK: - Helpers
    class HTTPClientSpy: HTTPClient {
        
        var requestedURLs: [URLRequest] {
            return performRequestInputs.map({$0.0})
        }
        
        var requestURLsCount: Int {
            return performRequestInputs.count
        }
        
        var performRequestInputs: [(urlRequest: URLRequest,
                                    completion: (HTTPClientResult) -> Void)] = []
        
        func perform(urlRequest: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            performRequestInputs.append((urlRequest, completion))
        }
        
        func fail(with error: Error, at index: Int = 0) {
            performRequestInputs[index].completion(.failure(error))
        }
        
        func success(with statusCode: Int, and data: Data = Data(), at index: Int = 0) {
            let url = performRequestInputs[index].urlRequest.url!
            let response = HTTPURLResponse(url: url,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            
            performRequestInputs[index].completion(.success((data: data, response: response!)))
        }
        
    }
    
    // factory method to create sut. it will help if the creation of changes then we only need to update this method rest of the test will not be effected
    func makeSUT(url: URL = URL(string: "https://some-url.com")!) -> (client: HTTPClientSpy, service: TopStoriesService) {
        let client = HTTPClientSpy()
        let sut = TopStoriesService(client: client, urlRequest: URLRequest(url: url))
        
        return (client, sut)
    }
    
    // expect method to remove duplicate code
    func expect(_ sut: TopStoriesService,
                toCompleteWith result: Result<[StoryItem], TopStoryServiceError>,
                on action: () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) {
        
        var receivedResult: [Result<[StoryItem], TopStoryServiceError>] = []
        
        sut.fetch { response in
            switch response {
            case .success(let item):
                receivedResult.append(.success(item))
            case .failure(let err):
                receivedResult.append(.failure(err))
            }
        }
        
        action()
        
        XCTAssertEqual(receivedResult, [result], file: file, line: line)
    }
     
}

extension StoryItem {
    // any increase them in future
    func makeJSON() -> [String: Any] {
        let codingKeys = TopStoriesServiceResponse.Results.CodingKeys.self
        let dict = [
            "id": self.id.uuidString,
            codingKeys.section.rawValue: self.section,
            codingKeys.title.rawValue: self.title,
            codingKeys.short_url.rawValue: self.shortURL,
            codingKeys.item_type.rawValue: self.itemType
        ].compactMapValues({$0})
        return dict
    }
}
