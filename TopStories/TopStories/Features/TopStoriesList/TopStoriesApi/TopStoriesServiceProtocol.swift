//
//  TopStoriesServiceProtocol.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/4/22.
//

import Foundation

enum TopStoryServiceError: Swift.Error {
    case internetConnectivity
    case unAuthorized
    case invalidData
}

protocol TopStoriesServiceProtocol {
    func fetch(completion: @escaping(Result<[StoryItem], TopStoryServiceError>) -> Void)
}
