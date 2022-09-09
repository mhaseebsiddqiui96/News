//
//  HTTPClient.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/5/22.
//

import Foundation

typealias HTTPClientResult = Result<(data: Data, response: HTTPURLResponse), Error>

protocol HTTPClient {
    @discardableResult
    func perform(urlRequest: URLRequest, completion: @escaping(HTTPClientResult) -> Void) -> URLSessionDataTask
}
