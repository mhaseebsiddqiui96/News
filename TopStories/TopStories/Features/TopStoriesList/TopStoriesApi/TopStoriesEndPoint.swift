//
//  TopStoriesEndPoint.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/6/22.
//

import Foundation

enum TopStoriesEndPoint: Routable {
   
    case getTopStories(for: String)
    
    var baseURL: String {
        return "https://api.nytimes.com"
    }
    
    var path: String {
        switch self {
        case .getTopStories(let category):
            return  "/svc/topstories/v2/\(category).json"
        }
    }
    var params: APIParams? {
        switch self {
        case .getTopStories:
            return ["api-key": Constants.ApiKeys.newYorkTimeApiKey]
        }
    }
    
    var method: APIMehtod {
        switch self {
        case .getTopStories:
            return .get
        }
    }
    
    var headers: APIHeaders? {
       return ["Content-Type": "application/json"]
    }
    
    var parameterEncoding: EncodingType {
        switch self {
        case .getTopStories:
            return .urlEncoding
        }
    }
    
}
