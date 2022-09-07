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
    var title: String = Constants.TopStoriesListStrings.navTitle
    let selectedSection: String = "home" // sending home as fixed for now but can be replaces with enum case in future and user can select this option
    var topStories: [StoryItemViewModel] = []

    
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
        topStories = stories.map({ item in
            return StoryItemViewModel(from: item) {
                self.router.routeToStoryDetail(with: item)
            }
        })
        view?.displayTopStories(topStories)
    }
    
    func presentError(_ error: TopStoryServiceError) {
        stopsLoaderAndDisplayErrorMessage(error.localizedDescription)
    }
    
    private func stopsLoaderAndDisplayErrorMessage(_ message: String) {
        view?.displayLoader(false)
        view?.displayErrorMessage(message)
    }
}
