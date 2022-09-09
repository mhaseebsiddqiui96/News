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
    
    //view state
    var storyDetailViewModel: StoryDetailViewModel?
    var title: String = Constants.StoryDetailsStrings.navTitle

    init(interface: TopStoryDetailViewProtocol, interactor: TopStoryDetailInteractorInputProtocol?, router: TopStoryDetailWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func viewLoaded() {
        interactor?.getTopStoryDetail()
    }
    
    func seeMoreTapped() {
        if let url = storyDetailViewModel?.completeStoryURL {
            router.routeToSeeMore(with: url)
        }
    }
    
    func presentStoryDetails(_ entity: StoryItem) {
        let viewModel = StoryDetailViewModel(form: entity)
        self.storyDetailViewModel = viewModel
        view?.displayStoryDetails(viewModel)
    }
    
    func presentImageData(_ data: Data) {
        var viewModel = storyDetailViewModel
        viewModel?.imgData = data
        storyDetailViewModel = viewModel
        view?.displayImage(data)
    }
    
}
