//
//  URL+QueryItems.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import Foundation

extension URL {
    mutating func appendingQueryItems(params: [String: String]) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        components.queryItems = []
        for param in params {
            components.queryItems?.append(URLQueryItem(name: param.key, value: param.value))
        }
        
        self = components.url!
        
    }
}
