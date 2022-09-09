//
//  StoryItem.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/4/22.
//

import Foundation

struct StoryItem: Equatable {
    
    let id: UUID
  
    let title: String?
    let abstract: String?
    let url: String?
    let byline: String?
    let multimedia: [Multimedia]?

    
    
    struct Multimedia: Equatable {
        let url : String?
        let format : Format?
       
        enum Format: String {
            case largeThumbnail
            case superJumbo
            case threeByTwoSmallAt2X
            case mediumThreeByTwo440
        }
        
    }
}
