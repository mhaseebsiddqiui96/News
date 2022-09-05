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

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case copyright = "copyright"
        case section = "section"
        case last_updated = "last_updated"
        case num_results = "num_results"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        last_updated = try values.decodeIfPresent(String.self, forKey: .last_updated)
        num_results = try values.decodeIfPresent(Int.self, forKey: .num_results)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
    
    struct Results : Codable {
        let id: String
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
            return StoryItem(id: UUID(uuidString: id) ?? UUID(),
                             section: section,
                             subsection: subsection,
                             title: title,
                             abstract: abstract,
                             url: url,
                             uri: uri,
                             byline: byline,
                             itemType: item_type,
                             updatedDateString: updated_date,
                             createdDateString: created_date,
                             publishedDateString: published_date,
                             materialTypeFacet: material_type_facet,
                             kicker: kicker,
                             desFacet: des_facet,
                             orgFacet: org_facet,
                             perFacet: per_facet,
                             geoFacet: geo_facet,
                             multimedia: storyItemMedia,
                             shortURL: short_url)
        }

        enum CodingKeys: String, CodingKey {

            case section = "section"
            case subsection = "subsection"
            case title = "title"
            case abstract = "abstract"
            case url = "url"
            case uri = "uri"
            case byline = "byline"
            case item_type = "item_type"
            case updated_date = "updated_date"
            case created_date = "created_date"
            case published_date = "published_date"
            case material_type_facet = "material_type_facet"
            case kicker = "kicker"
            case des_facet = "des_facet"
            case org_facet = "org_facet"
            case per_facet = "per_facet"
            case geo_facet = "geo_facet"
            case multimedia = "multimedia"
            case short_url = "short_url"
            case id = "id"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            section = try values.decodeIfPresent(String.self, forKey: .section)
            subsection = try values.decodeIfPresent(String.self, forKey: .subsection)
            title = try values.decodeIfPresent(String.self, forKey: .title)
            abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
            url = try values.decodeIfPresent(String.self, forKey: .url)
            uri = try values.decodeIfPresent(String.self, forKey: .uri)
            byline = try values.decodeIfPresent(String.self, forKey: .byline)
            item_type = try values.decodeIfPresent(String.self, forKey: .item_type)
            updated_date = try values.decodeIfPresent(String.self, forKey: .updated_date)
            created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
            published_date = try values.decodeIfPresent(String.self, forKey: .published_date)
            material_type_facet = try values.decodeIfPresent(String.self, forKey: .material_type_facet)
            kicker = try values.decodeIfPresent(String.self, forKey: .kicker)
            des_facet = try values.decodeIfPresent([String].self, forKey: .des_facet)
            org_facet = try values.decodeIfPresent([String].self, forKey: .org_facet)
            per_facet = try values.decodeIfPresent([String].self, forKey: .per_facet)
            geo_facet = try values.decodeIfPresent([String].self, forKey: .geo_facet)
            multimedia = try values.decodeIfPresent([Multimedia].self, forKey: .multimedia)
            short_url = try values.decodeIfPresent(String.self, forKey: .short_url)
            if let idString = try? values.decodeIfPresent(String.self, forKey: .id) {
                id = idString
            } else {
                id = UUID().uuidString
            }
        }

        
        struct Multimedia : Codable {
            let url : String?
            let format : String?
            let height : Int?
            let width : Int?
            let type : String?
            let subtype : String?
            let caption : String?
            let copyright : String?

            enum CodingKeys: String, CodingKey {

                case url = "url"
                case format = "format"
                case height = "height"
                case width = "width"
                case type = "type"
                case subtype = "subtype"
                case caption = "caption"
                case copyright = "copyright"
            }

            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                url = try values.decodeIfPresent(String.self, forKey: .url)
                format = try values.decodeIfPresent(String.self, forKey: .format)
                height = try values.decodeIfPresent(Int.self, forKey: .height)
                width = try values.decodeIfPresent(Int.self, forKey: .width)
                type = try values.decodeIfPresent(String.self, forKey: .type)
                subtype = try values.decodeIfPresent(String.self, forKey: .subtype)
                caption = try values.decodeIfPresent(String.self, forKey: .caption)
                copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
            }

            var storyMultiMedia: StoryItem.Multimedia {
                return StoryItem.Multimedia(url: url, format: format, height: height, width: width, type: type, subtype: subtype, caption: caption, copyright: copyright)
            }
        }
    }

}


