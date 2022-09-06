//
//  TopStoriesPresenter.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import Foundation

class TopStoriesListPresenter: TopStoriesListPresenterProtocol {
    
    var interactor: TopStoriesListInteractorInputProtocol?
    weak private var view: TopStoriesListViewProtocol?
    private let router: TopStoriesListWireframeProtocol
        
    // View Representation
    let title: String = Constants.TopStoriesListStrings.navTitle
    let selectedSection: String = "home" // sending home as fixed for now but can be replaces with enum case in future and user can select this option
    
    init(interface: TopStoriesListViewProtocol, interactor: TopStoriesListInteractorInputProtocol?, router: TopStoriesListWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func viewLoaded() {
        
        view?.displayLoader(true)
        interactor?.getTopStoriesList(for: selectedSection)
    }

}

extension TopStoriesListPresenter: TopStoriesListInteractorOutputProtocol {
    func presentListOfStories(_ stories: [StoryItem]) {
        view?.displayLoader(false)
        view?.displayTopStories(stories.map({StoryItemViewModel(from: $0)}))
    }
    
    func presentConnectivityError() {
        stopsLoaderAndDisplayErrorMessage(Constants.TopStoriesListStrings.connectivityErrorMessage)
    }
    
    func presentInvalidDataError() {
        stopsLoaderAndDisplayErrorMessage(Constants.TopStoriesListStrings.invalidDataMessage)
    }
    
    func presentAuthError() {
        stopsLoaderAndDisplayErrorMessage(Constants.TopStoriesListStrings.authenticationFailed)
    }
    
    private func stopsLoaderAndDisplayErrorMessage(_ message: String) {
        view?.displayLoader(false)
        view?.displayErrorMessage(message)
    }
}
