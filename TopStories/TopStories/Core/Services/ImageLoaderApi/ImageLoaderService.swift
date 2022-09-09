//
//  ImageLoderApi.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import Foundation

class ImageLoaderSerivce: ImageLoaderSerivceProtocol {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(with url: URL, completion: @escaping(Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        let request = client.perform(urlRequest: URLRequest(url: url)) { response in
            switch response {
            case .success(let result):
                completion(.success(result.data))
            case .failure(let err):
                completion(.failure(err))
            }
        }
        
        return request
    }
}
