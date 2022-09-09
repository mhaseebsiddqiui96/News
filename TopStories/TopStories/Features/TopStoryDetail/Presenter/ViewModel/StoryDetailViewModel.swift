//
//  StoryDetailViewModel.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import Foundation

struct StoryDetailViewModel: Equatable {
    let title: String
    let author: String
    let description: String
    let url: URL?
    var imgData: Data?
    let completeStoryURL: URL?
}

extension StoryDetailViewModel {
    init(form model: StoryItem) {
        let title = model.title ?? "--"
        let author = model.byline ?? "--"
        let description = model.abstract ?? "--"
        let url = URL(string: model.multimedia?.first(where: {$0.format == .superJumbo})?.url ?? "")
        let completeStoryURL = URL(string: model.url ?? "")

        self.init(title: title, author: author, description: description, url: url, completeStoryURL: completeStoryURL)
    }
}
