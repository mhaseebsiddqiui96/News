//
//  TopStoriesListProtocols.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/6/22.
//

import Foundation

// MARK: Wireframe -
protocol TopStoriesListWireframeProtocol: AnyObject {
    func routeToStoryDetail(with entitiy: StoryItem)
}

// MARK: Interactor -
protocol TopStoriesListInteractorOutputProtocol: AnyObject {

    /* Interactor -> Presenter */
    func presentListOfStories(_ stories: [StoryItem])
    func presentConnectivityError()
    func presentInvalidDataError()
    func presentAuthError()
}

protocol TopStoriesListInteractorInputProtocol: AnyObject {

    var presenter: TopStoriesListInteractorOutputProtocol? { get set }

    /* Presenter -> Interactor */
    func getTopStoriesList(for section: String)
}


// MARK: Presenter -
protocol TopStoriesListPresenterProtocol: AnyObject {

    var interactor: TopStoriesListInteractorInputProtocol? { get set }
    func viewLoaded()
}

// MARK: View -
protocol TopStoriesListViewProtocol: AnyObject {

    var presenter: TopStoriesListPresenterProtocol? { get set }

    /* Presenter -> ViewController */
    func displayTopStories(_ viewModel: [StoryItemViewModel])
    func displayErrorMessage(_ message: String)
    func displayLoader(_ show: Bool)
}
