//
//  ImageLoaderServiceProtocol.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import Foundation

protocol ImageLoaderSerivceProtocol: AnyObject {
    func loadImageData(with url: URL, completion: @escaping(Result<Data, Error>) -> Void) -> URLSessionDataTask?
}
