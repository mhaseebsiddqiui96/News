//
//  Constants.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/6/22.
//

import Foundation

struct Constants {
    
    struct ApiKeys {
        static let newYorkTimeApiKey = "zir2gnpsJpBkjwlsrh2fknSjGWjwfBE2"
    }
    
    // this should be to some localized file, no time :(
    struct TopStoriesListStrings {
        static let invalidDataMessage = "Something went wrong!"
        static let connectivityErrorMessage = "Unable to connect to a server!"
        static let authenticationFailed = "Authentication Failed!"
        
        static let navTitle: String = "#Top Stories"
    }
}
