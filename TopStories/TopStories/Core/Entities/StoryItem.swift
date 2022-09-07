//
//  StoryItem.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/4/22.
//

import Foundation

struct StoryItem: Equatable {
    
    let id: UUID
    let section: String?
    let subsection: String?
    let title: String?
    let abstract: String?
    let url: String?
    let uri: String?
    let byline: String?
    let itemType: String?
    let updatedDate: Date?
    let createdDate: Date?
    let publishedDate: Date?
    let multimedia: [Multimedia]?

    
    
    struct Multimedia: Equatable {
        let url : String?
        let format : Format?
        let height : Int?
        let width : Int?
        let type : String?
        let subtype : String?
        let caption : String?
        let copyright : String?
        
        enum Format {
            case largeThumbnail
            case superJumbo
            case threeByTwoSmallAt2X
        }
        
    }
}
