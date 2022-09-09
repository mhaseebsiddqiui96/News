//
//  TopStoryDetailInteractor.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.

import UIKit

class TopStoryDetailInteractor: TopStoryDetailInteractorInputProtocol {

    weak var presenter: TopStoryDetailInteractorOutputProtocol?
    var imageLoaderService: ImageLoaderSerivceProtocol
    let storyEntity: StoryItem
    
    
    init(_ storyEntity: StoryItem, service: ImageLoaderSerivceProtocol) {
        self.storyEntity = storyEntity
        self.imageLoaderService = service
    }
    
    func getTopStoryDetail() {
        
        presenter?.presentStoryDetails(storyEntity)
        guard let URL = URL(string: storyEntity.multimedia?.first(where: {$0.format == .superJumbo})?.url ?? "") else {return}
        _ = self.imageLoaderService.loadImageData(with: URL) {[weak self] result in
            switch result {
            case .success(let data):
                self?.presenter?.presentImageData(data)
            case .failure:
                break
            }
        }
    }
    
}
