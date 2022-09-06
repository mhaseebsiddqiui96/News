//
//  TopStoriesServiceResponse.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/5/22.
//

import Foundation

struct TopStoriesServiceResponse: Codable {
    let status : String?
    let copyright : String?
    let section : String?
    let last_updated : String?
    let num_results : Int?
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
        let updated_date : Date?
        let created_date : Date?
        let published_date : Date?
        let material_type_facet : String?
        let kicker : String?
        let des_facet : [String]?
        let org_facet : [String]?
        let per_facet : [String]?
        let geo_facet : [String]?
        let multimedia : [Multimedia]?
        let short_url : String?
        
        
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
                             updatedDate: updated_date,
                             createdDate: created_date,
                             publishedDate: published_date,
                             materialTypeFacet: material_type_facet,
                             kicker: kicker,
                             desFacet: des_facet,
                             orgFacet: org_facet,
                             perFacet: per_facet,
                             geoFacet: geo_facet,
                             multimedia: storyItemMedia,
                             shortURL: short_url)
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


