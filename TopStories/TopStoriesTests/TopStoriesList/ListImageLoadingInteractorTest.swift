//
//  ListImageLoadingInteractorTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/9/22.
//

import XCTest
@testable import TopStories

class ListImageLoadingInteractorTest: XCTestCase {

    func test_loadImageData_doesNotCallServiceIfOngoingRequest() throws {
        
        let (sut, serviceSpy, presenterSpy) = makeSUT()
        // setup
        
        let (fakeDataTask, url) = FakeHTTPDataTask.create(string: "https://some-url.com")
        sut.ongoingRequests[0] = fakeDataTask
        
        // test
        sut.loadImageData(at: 0, for: url)
        
        // assert
        XCTAssertNil(serviceSpy.loadImageCalled[url])
        XCTAssertEqual(presenterSpy.presentImageDataCalled, [])
        
    }
    
    func test_loadImageData_callServiceIfNoOngoingRequest_presentsImageDataOnSuccessFromService() throws {
        let (sut, serviceSpy, presenterSpy) = makeSUT()

        let url = URL(string: "https://some-url.com")!
        
        // test
        sut.loadImageData(at: 0, for: url)
        
        //checking ongoing request is not nil
        XCTAssertNotNil(sut.ongoingRequests[0])

        // assert
        XCTAssertNotNil(serviceSpy.loadImageCalled[url])
        
        let data = Data()
        let expectedPresenterOutput = PresenterSpy.ImageCallBack(index: 0, url: url, data: data)
        
        // firing the completion handler
        serviceSpy.loadImageCalled[url]?(.success(data))
        
        
        // presenter should be fired
        XCTAssertEqual(presenterSpy.presentImageDataCalled, [expectedPresenterOutput])
        XCTAssertNil(sut.ongoingRequests[0])
    }
    
    func test_loadImageData_callServiceIfNoOngoingRequest_presentsErrorOnFailureFromService() throws {
        let (sut, serviceSpy, presenterSpy) = makeSUT()

        let url = URL(string: "https://some-url.com")!
        
        // test
        sut.loadImageData(at: 0, for: url)
        
        //checking ongoing request is not nil
        XCTAssertNotNil(sut.ongoingRequests[0])
        
        // assert
        XCTAssertNotNil(serviceSpy.loadImageCalled[url])
                
        let error = FakeError.fakeError
        serviceSpy.loadImageCalled[url]?(.failure(error))
        
        XCTAssertEqual(presenterSpy.presentErrorCalled, [error.localizedDescription])
        XCTAssertNil(sut.ongoingRequests[0])

    }
    
    func test_loadImageData_callServiceIfNoOngoingRequest_presentsNoErrorOnCancelFailureFromService() throws {
        let (sut, serviceSpy, presenterSpy) = makeSUT()

        let url = URL(string: "https://some-url.com")!
        
        // test
        sut.loadImageData(at: 0, for: url)
        
        //checking ongoing request is not nil
        XCTAssertNotNil(sut.ongoingRequests[0])
        
        // assert
        XCTAssertNotNil(serviceSpy.loadImageCalled[url])
                
        let error = NSError(domain: "domain", code: NSURLErrorCancelled)
        serviceSpy.loadImageCalled[url]?(.failure(error))
        
        XCTAssertEqual(presenterSpy.presentErrorCalled, [])

    }
    
    func test_cancelLoad_cancelSessionDataTask() throws {
        
        let (sut, _, _) = makeSUT()
        
        let (fakeDataTask, _) = FakeHTTPDataTask.create(string: "https://some-url.com")
        sut.ongoingRequests[0] = fakeDataTask
        
        sut.cancelLoad(at: 0)
        
        XCTAssertEqual(fakeDataTask.cancelCalled, 1)
        XCTAssertNil(sut.ongoingRequests[0])
    
    }
 
    //MARK: - Helpers
    class ImageLoadingServiceSpy: ImageLoaderSerivceProtocol {
        
        var loadImageCalled: [URL: (Result<Data, Error>) -> Void] = [:]
        
        func loadImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
            loadImageCalled[url] = completion
            // I should mocked it but its too late now
            return URLSessionDataTask()
        }
        
    }
    
    class PresenterSpy: ListImageDataLoadingOutputProtocol {
        struct ImageCallBack: Equatable {
            let index: Int
            let url: URL
            let data: Data
        }
        var presentImageDataCalled = [ImageCallBack]()
        var presentErrorCalled = [String]()
        
        func presentImageData(at index: Int, having url: URL, with data: Data) {
            presentImageDataCalled.append(ImageCallBack(index: index, url: url, data: data))
        }
        
        func presentError(_ errMsg: String) {
            presentErrorCalled.append(errMsg)
        }
    }
    
    class FakeHTTPDataTask: HTTPDataTask {
        var cancelCalled = 0
        var currentURL: URL?
        
        func cancel() {
            cancelCalled += 1
        }
        
        var url: URL? {
            return currentURL
        }
        
        static func create(string: String) -> (FakeHTTPDataTask, URL) {
            let fakeDataTask = FakeHTTPDataTask()
            let url = URL(string: string)!
            fakeDataTask.currentURL = url
            return (fakeDataTask, url)
        }
    }
    
    func makeSUT() -> (sut: ListImageDataLoadingInteractor, service: ImageLoadingServiceSpy, presenter: PresenterSpy ) {
        let serviceSpy = ImageLoadingServiceSpy()
        let sut = ListImageDataLoadingInteractor(service: serviceSpy)
        let presenter = PresenterSpy()
        sut.presenter = presenter
        
        return (sut, serviceSpy, presenter)
    }
    
    enum FakeError: Swift.Error, LocalizedError {
        case fakeError
        
        public var errorDescription: String? {
            switch self {
            case .fakeError:
                return NSLocalizedString("Unable to connect to server!", comment: "")
            }
        }
    }
    
}
