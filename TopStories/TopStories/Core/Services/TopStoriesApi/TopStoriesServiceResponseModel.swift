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
        let title : String?
        let abstract : String?
        let url : String?
        let byline : String?
        let multimedia : [Multimedia]?
                
        var storyItemMedia: [StoryItem.Multimedia]? {
            return multimedia?.map({$0.storyMultiMedia})
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case abstract
            case url
            case byline
            case multimedia
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try? values.decodeIfPresent(String.self, forKey: .id)
            title = try? values.decodeIfPresent(String.self, forKey: .title)
            abstract = try? values.decodeIfPresent(String.self, forKey: .abstract)
            url = try? values.decodeIfPresent(String.self, forKey: .url)
            byline = try? values.decodeIfPresent(String.self, forKey: .byline)
            multimedia = try? values.decodeIfPresent([Multimedia].self, forKey: .multimedia)
        }
        
        var storyItem: StoryItem {
            return StoryItem(id: UUID(uuidString: id ?? UUID().uuidString) ?? UUID(),

                             title: title,
                             abstract: abstract,
                             url: url,
                             byline: byline,
                             multimedia: storyItemMedia)
        }

        
        struct Multimedia : Codable {
            let url : String?
            let format : Format?
        
            var storyMultiMedia: StoryItem.Multimedia {
                return StoryItem.Multimedia(url: url, format: format?.storyMediaFormat)
            }

            enum CodingKeys: String, CodingKey {
                case url
                case format
            }

            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                url = try? values.decodeIfPresent(String.self, forKey: .url)
                format = try? values.decodeIfPresent(Format.self, forKey: .format)
            }
            
            
            enum Format: String, Codable {
                case largeThumbnail = "Large Thumbnail"
                case superJumbo = "Super Jumbo"
                case threeByTwoSmallAt2X = "threeByTwoSmallAt2X"
                case mediumThreeByTwo440 = "mediumThreeByTwo440"
                
                var storyMediaFormat: StoryItem.Multimedia.Format {
                    switch self {
                        
                    case .largeThumbnail:
                        return .largeThumbnail
                    case .superJumbo:
                        return .superJumbo
                    case .threeByTwoSmallAt2X:
                        return .threeByTwoSmallAt2X
                    case .mediumThreeByTwo440:
                        return .mediumThreeByTwo440
                    
                    }
                }
            }
        }
        
    }

}


