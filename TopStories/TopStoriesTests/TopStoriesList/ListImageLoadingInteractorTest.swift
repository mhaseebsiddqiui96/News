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
        XCTAssertEqual(serviceSpy.loadImageCalled, [])
        XCTAssertEqual(presenterSpy.presentImageDataCalled, [])
        
    }
 
    //MARK: - Helpers
    class ImageLoadingServiceSpy: ImageLoaderSerivceProtocol {
        
        var loadImageCalled: [URL] = []
        
        func loadImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
            loadImageCalled.append(url)
            return nil
        }
        
    }
    
    class PresenterSpy: ListImageDataLoadingOutputProtocol {
        struct ImageCallBack: Equatable {
            let index: Int
            let url: URL
            let data: Data
        }
        var presentImageDataCalled = [ImageCallBack]()
        
        func presentImageData(at index: Int, having url: URL, with data: Data) {
            presentImageDataCalled.append(ImageCallBack(index: index, url: url, data: data))
        }
        
        func presentError(_ errMsg: String) {
            
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
}
