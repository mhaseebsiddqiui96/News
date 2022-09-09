//
//  LocalizeStrings.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/9/22.
//

import Foundation

enum LocalizedStrings: String, Localizable {
    case storyListTitle = "story_list_title"
    case storyDetailTitle = "story_detail_title"
    case seeMoreButtonTitle = "see_more_button_title"
    
    var tableName: String {
        return "Localized"
    }
}
