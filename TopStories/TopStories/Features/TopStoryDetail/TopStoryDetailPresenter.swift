//
//  TopStoryDetailPresenter.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.


import UIKit

class TopStoryDetailPresenter: TopStoryDetailPresenterProtocol, TopStoryDetailInteractorOutputProtocol {

    weak private var view: TopStoryDetailViewProtocol?
    var interactor: TopStoryDetailInteractorInputProtocol?
    private let router: TopStoryDetailWireframeProtocol

    init(interface: TopStoryDetailViewProtocol, interactor: TopStoryDetailInteractorInputProtocol?, router: TopStoryDetailWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func presentStoryDetails(_ entity: StoryItem) {
        
    }
    
}
