//
//  ImageDataLoaderInteractor.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import XCTest
@testable import TopStories

class ImageDataLoaderInteractorTest: XCTestCase {

    func test_loadImageData_deliversDataFromStore() throws {
        let dataStore = DataStoreStub()
        let service = Service()
        let sut = CachedImageLoadingService(dataStore: dataStore, serivce: service)
        
        let url = URL(string: "https://some-url.com")!
        let imgData = Data()
        dataStore.stub[url] = imgData
        
        
        var receivedData: Data?
        _ = sut.loadImageData(with: url) { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure:
                XCTFail("Expected Success but found failure instead")
            }
        }
        
        XCTAssertEqual(receivedData, imgData)
        
    }
    
    func test_loadImageData_deliversDataFromService() throws {
        let dataStore = DataStoreStub()
        let service = Service()
        let sut = CachedImageLoadingService(dataStore: dataStore, serivce: service)
        
        let url = URL(string: "https://some-url.com")!
        let imgData = Data()
        
        
        var receivedData: Data?
        _ = sut.loadImageData(with: url) { result in
            switch result {
            case .success(let data):
                receivedData = data
            case .failure:
                XCTFail("Expected Success but found failure instead")
            }
        }
        service.completions[0](.success(imgData))
        XCTAssertEqual(receivedData, imgData)
        XCTAssertEqual(dataStore.savedData, [imgData])
    }

    func test_loadImageData_deliversErrorFromService() throws {
        let dataStore = DataStoreStub()
        let service = Service()
        let sut = CachedImageLoadingService(dataStore: dataStore, serivce: service)
        
        let url = URL(string: "https://some-url.com")!
        let err = NSError(domain: "domain", code: 1)
        
        
        var receivedError: NSError?
        _ = sut.loadImageData(with: url) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but found Success instead")
            case .failure(let error as NSError):
                receivedError = error
            }
        }
        service.completions[0](.failure(err))
        XCTAssertEqual(receivedError?.code, err.code)
        XCTAssertEqual(receivedError?.domain, err.domain)
    }
    
    
    
    //MARK: - Helpers
    class DataStoreStub: ImageDataStore {
        
        var requestURLs: [URL] = []
        var stub: [URL: Data] = [:]
        var savedData = [Data]()
        
        func saveImageData(_ data: Data, for url: URL) {
            savedData.append(data)
        }
        
        func getImageData(for url: URL) -> Data? {
            return stub[url]
        }
        
    }
    
    class Service: ImageLoaderSerivceProtocol {
       
        
        var completions: [(Result<Data, Error>) -> Void] = []
        
        func loadImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
            completions.append(completion)
            return  nil
        }
        
        
    }
    
}
