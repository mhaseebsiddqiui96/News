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

extension TopStoryServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .internetConnectivity:
            return NSLocalizedString("Unable to connect to server!", comment: "")
        case .invalidData:
            return NSLocalizedString("Something went wrong!", comment: "")
        case .unAuthorized:
            return NSLocalizedString("You are not authorize to perform this action", comment: "")
        }
    }
}

protocol TopStoriesServiceProtocol {
    func fetch(completion: @escaping(Result<[StoryItem], TopStoryServiceError>) -> Void)
}
