//
//  ListImageDataLoaderInteractor.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import Foundation

protocol ListImageDataLoadingInteractorProtocol: AnyObject {
    func loadImageData(at index: Int, for url: URL)
    func cancelLoad(at index: Int)
}

protocol HTTPDataTask {
    func cancel()
    var url: URL? {get}
}

extension URLSessionDataTask: HTTPDataTask {
    var url: URL? {
        return self.originalRequest?.url
    }
}

class ListImageDataLoadingInteractor: ListImageDataLoadingInteractorProtocol {
    
    let imageDataLoadingInteractor: ImageLoaderSerivceProtocol
    var ongoingRequests = [Int: HTTPDataTask]()
    var presenter: ListImageDataLoadingOutputProtocol?

    init(service: ImageLoaderSerivceProtocol) {
        self.imageDataLoadingInteractor = service
    }
    
    func loadImageData(at index: Int, for url: URL) {
        if let task = ongoingRequests[index], task.url == url {
            // do nothing just return from here as already request is there
            return
        }
        
        let task = imageDataLoadingInteractor.loadImageData(with: url) {[weak self] result in
            switch result {
            case .success(let data):
                self?.presenter?.presentImageData(at: index, having: url, with: data)
            case .failure(let err as NSError):
                if err.code != NSURLErrorCancelled {
                    self?.presenter?.presentError(err.localizedDescription)
                }
            }
            self?.ongoingRequests.removeValue(forKey: index)
        }
        
        ongoingRequests[index] = task
    }
    
    func cancelLoad(at index: Int) {
        self.ongoingRequests[index]?.cancel()
        self.ongoingRequests.removeValue(forKey: index)
    }
}
