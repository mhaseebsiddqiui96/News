//
//  TopStoriesService.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/4/22.
//

import Foundation

typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

protocol HTTPClient {
    func perform(urlRequest: URLRequest, completion: @escaping(HTTPClientResult) -> Void)
}

class TopStoriesService: TopStoriesServiceProtocol {
  
    private let client: HTTPClient
    private let urlRequest: URLRequest
    
    init(client: HTTPClient, urlRequest: URLRequest) {
        self.client = client
        self.urlRequest = urlRequest
    }
    
    func fetch(completion: @escaping (Result<StoryItem, Error>) -> Void) {
        client.perform(urlRequest: urlRequest) { response in
            
        }
    }
}
