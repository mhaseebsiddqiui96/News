//
//  StoryItem.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/4/22.
//

import Foundation

struct StoryItem: Equatable {
    
    let id: UUID
    let section : String?
    let subsection : String?
    let title : String?
    let abstract : String?
    let url : String?
    let uri : String?
    let byline : String?
    let itemType : String?
    let updatedDateString : String?
    let createdDateString : String?
    let publishedDateString : String?
    let materialTypeFacet : String?
    let kicker : String?
    let desFacet : [String]?
    let orgFacet : [String]?
    let perFacet : [String]?
    let geoFacet : [String]?
    let multimedia : [Multimedia]?
    let shortURL : String?

    
    
    struct Multimedia {
        let url : String?
        let format : String?
        let height : Int?
        let width : Int?
        let type : String?
        let subtype : String?
        let caption : String?
        let copyright : String?
        
    }
    
    static func == (lhs: StoryItem, rhs: StoryItem) -> Bool {
        return lhs.id == rhs.id
    }
    
}
