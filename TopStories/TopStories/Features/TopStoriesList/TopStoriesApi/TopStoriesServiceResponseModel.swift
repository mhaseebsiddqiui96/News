//
//  TopStoriesServiceResponse.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/5/22.
//

import Foundation

struct TopStoriesServiceResponse: Codable {
    let results : [Results]?

    struct Results : Codable {
        let id: String?
        let section : String?
        let subsection : String?
        let title : String?
        let abstract : String?
        let url : String?
        let uri : String?
        let byline : String?
        let item_type : String?
        let updated_date : String?
        let created_date : String?
        let published_date : String?

        let multimedia : [Multimedia]?
                
        var storyItemMedia: [StoryItem.Multimedia]? {
            return multimedia?.map({$0.storyMultiMedia})
        }
        
        var storyItem: StoryItem {
            return StoryItem(id: UUID(uuidString: id ?? UUID().uuidString) ?? UUID(),
                             section: section,
                             subsection: subsection,
                             title: title,
                             abstract: abstract,
                             url: url,
                             uri: uri,
                             byline: byline,
                             itemType: item_type,
                             updatedDate: Date(),
                             createdDate: Date(),
                             publishedDate: Date(),
                             multimedia: storyItemMedia)
        }

        
        struct Multimedia : Codable {
            let url : String?
            let format : Format?
            let height : Int?
            let width : Int?
            let type : String?
            let subtype : String?
            let caption : String?
            let copyright : String?


            var storyMultiMedia: StoryItem.Multimedia {
                return StoryItem.Multimedia(url: url, format: format?.storyMediaFormat, height: height, width: width, type: type, subtype: subtype, caption: caption, copyright: copyright)
            }
            
            
            enum Format: String, Codable {
                case largeThumbnail = "Large Thumbnail"
                case superJumbo = "Super Jumbo"
                case threeByTwoSmallAt2X = "threeByTwoSmallAt2X"
                
                var storyMediaFormat: StoryItem.Multimedia.Format {
                    switch self {
                        
                    case .largeThumbnail:
                        return .largeThumbnail
                    case .superJumbo:
                        return .superJumbo
                    case .threeByTwoSmallAt2X:
                        return .threeByTwoSmallAt2X
                    }
                }
            }
        }
        
    }

}


