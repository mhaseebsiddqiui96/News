//
//  TopStoriesService.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/4/22.
//

import Foundation

class TopStoriesService: TopStoriesServiceProtocol {

  
    private let client: HTTPClient
    private let urlRequest: URLRequest
    
    enum Error: Swift.Error {
        case internetConnectivity
        case unAuthorized
        case invalidData
    }
    
    init(client: HTTPClient, urlRequest: URLRequest) {
        self.client = client
        self.urlRequest = urlRequest
    }
    
    func fetch(completion: @escaping (Result<[StoryItem], Error>) -> Void) {
        client.perform(urlRequest: urlRequest) {[weak self] response in
            guard let self = self else {return}
            switch response {
            case .success(let result):
                completion(self.parseSuccessResponse(result))
            case .failure:
                completion(.failure(Error.internetConnectivity))
            }
        }
    }
    
    // may be move this to some helper class in future
    private func parseSuccessResponse(_ result: ((data: Data, response: HTTPURLResponse))) -> Result<[StoryItem], Error> {
       
        if result.response.statusCode == 200, let apiResponse = self.decodeResponse(from: result.data) {
            return .success(apiResponse.results?.map({$0.storyItem}) ?? [])
        } else if result.response.statusCode == 401 {
            return .failure(Error.unAuthorized)
        } else {
            return .failure(Error.invalidData)
        }
    }
    
    private func decodeResponse(from data: Data) -> TopStoriesServiceResponse? {
        return try? JSONDecoder().decode(TopStoriesServiceResponse.self, from: data)
    }
}
