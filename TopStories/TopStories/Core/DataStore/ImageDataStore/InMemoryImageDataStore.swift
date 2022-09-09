//
//  InMemoryImageDataStore.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import Foundation

class InMemoryImageDataStore: ImageDataStore {
    static var store = [String: Data]()
    
    func saveImageData(_ data: Data, for url: URL) {
        InMemoryImageDataStore.store[url.absoluteString] = data
    }
    
    func getImageData(for url: URL) -> Data? {
        return InMemoryImageDataStore.store[url.absoluteString]
    }
    
}
