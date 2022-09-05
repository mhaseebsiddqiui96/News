//
//  URLSessionClient.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/5/22.
//

import Foundation

class URLSessionClient: HTTPClient {
    
    let session: URLSession
    
    init(_ _session: URLSession = URLSession.shared) {
        session = _session
    }
    
    func perform(urlRequest: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
        let task = session.dataTask(with: urlRequest) { data, response, err in
            if let err = err {
                completion(.failure(err))
            }
        }
        
        task.resume()
    }
}
