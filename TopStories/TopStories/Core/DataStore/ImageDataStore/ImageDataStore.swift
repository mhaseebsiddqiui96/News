//
//  ImageDataStoreProtocol.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import Foundation

protocol ImageDataStore: AnyObject {
    func saveImageData(_ data: Data, for url: URL)
    func getImageData(for url: URL) -> Data?
}
