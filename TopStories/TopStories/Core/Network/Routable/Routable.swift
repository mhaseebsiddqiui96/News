//
//  Routable.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import Foundation


enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum EncodingType {
    case urlEncoding
    case jsonEncoding
}

typealias APIParams = [String: String]
typealias APIHeaders = [String: String]
typealias APIMehtod = APIMethod

/// This should be implemented by all concrete routers
protocol Routable {

    /// baseURL
    var baseURL: String { get }
    /// by default method is HTTPMethod.get
    var method: APIMehtod { get }

    /// path should be appended with baseURL
    var path: String { get }
    var parameterEncoding: EncodingType { get }
    var headers: APIHeaders? { get }
    var params: APIParams? { get }
}

extension Routable {
   
    func asURLRequest() -> URLRequest {
        var url = URL(string: baseURL)!
        
        // Appending Query Item if it is get request
        if method == .get {
            url.appendingQueryItems(params: params ?? [:])
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        if let header = headers {
            header.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
        // Parameters
        if let parameters = params {
            if method != .get {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                
            }
            
        }
        return urlRequest
        
    }
}
