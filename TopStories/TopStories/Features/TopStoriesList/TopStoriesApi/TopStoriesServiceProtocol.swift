//
//  TopStoriesServiceProtocol.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/4/22.
//

import Foundation

protocol TopStoriesServiceProtocol {
    associatedtype Error: Swift.Error
    func fetch(completion: @escaping(Result<[StoryItem], Error>) -> Void)
}
