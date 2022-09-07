//
//  TopStoryDetailInteractor.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.

import UIKit

class TopStoryDetailInteractor: TopStoryDetailInteractorInputProtocol {

    weak var presenter: TopStoryDetailInteractorOutputProtocol?
    let storyEntity: StoryItem
    
    init(_ storyEntity: StoryItem) {
        self.storyEntity = storyEntity
    }
    
    func getTopStoryDetail() {
        presenter?.presentStoryDetails(storyEntity)
    }
    
}
