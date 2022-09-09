//
//  ImageDataLoaderInteractor.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import Foundation

class CachedImageLoadingService: ImageLoaderSerivceProtocol {
   
    let imageDataStore: ImageDataStore
    let imageLoaderService: ImageLoaderSerivceProtocol
    
    init(dataStore: ImageDataStore, serivce: ImageLoaderSerivceProtocol) {
        self.imageDataStore = dataStore
        self.imageLoaderService = serivce
    }
    
    func loadImageData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        
        // checking cache for images
        if let imgData = imageDataStore.getImageData(for: url) {
            completion(.success(imgData))
            return nil
        }
        
        let task = imageLoaderService.loadImageData(with: url) { result in
            switch result {
            case .success(let imgData):
                self.imageDataStore.saveImageData(imgData, for: url)
                completion(.success(imgData))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    
        return task
    }
    
}
