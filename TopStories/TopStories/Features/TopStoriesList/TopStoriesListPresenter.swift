//
//  TopStoriesPresenter.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import Foundation

class TopStoriesPresenter: TopStoriesListPresenterProtocol {
    
    var interactor: TopStoriesListInteractorInputProtocol?
    
    weak private var view: TopStoriesListViewProtocol?
    private let router: TopStoriesListWireframeProtocol
    
    init(interface: TopStoriesListViewProtocol, interactor: TopStoriesListInteractorInputProtocol?, router: TopStoriesListWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
