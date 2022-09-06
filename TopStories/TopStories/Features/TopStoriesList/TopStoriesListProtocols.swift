//
//  TopStoriesListProtocols.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/6/22.
//

import Foundation

// MARK: Interactor -
protocol TopStoriesListInteractorOutputProtocol: AnyObject {

    /* Interactor -> Presenter */
    func presentListOfStories(_ stories: [StoryItem])
    func presentConnectivityError()
    func presentInvalidDataError()
}

protocol TopStoriesListInteractorInputProtocol: AnyObject {

    var presenter: TopStoriesListInteractorOutputProtocol? { get set }

    /* Presenter -> Interactor */
    func getTopStoriesList(for section: String)
}
