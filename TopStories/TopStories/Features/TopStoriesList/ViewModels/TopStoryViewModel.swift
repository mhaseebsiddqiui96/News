//
//  TopStoryViewModel.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import Foundation

struct StoryItemViewModel: Equatable {
    let imageURL: URL? // it can be nill
    let title: String
    let author: String
}


extension StoryItemViewModel {
    init(from entity: StoryItem)  {
        let url = URL(string: entity.multimedia?.first(where: {$0.format == .largeThumbnail})?.url ?? "") 
        let title = entity.title ?? "N/A"
        let author = entity.byline ?? "N/a"
        self.init(imageURL: url, title: title, author: author)
    }
}
