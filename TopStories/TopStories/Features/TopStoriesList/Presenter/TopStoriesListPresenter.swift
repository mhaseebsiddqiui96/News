//
//  TopStoriesPresenter.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import Foundation

class TopStoriesListPresenter: TopStoriesListPresenterProtocol {
    
    var interactor: TopStoriesListInteractorInputProtocol?
    var listImageLoadingInteractor: ListImageDataLoadingInteractorProtocol?
    
    weak private var view: TopStoriesListViewProtocol?
    private let router: TopStoriesListWireframeProtocol
        
    // View Representation
    var title: String = Constants.TopStoriesListStrings.navTitle
    let selectedSection: String = "home" // sending home as fixed for now but can be replaces with enum case in future and user can select this option
    var topStories: [StoryItemViewModel] = []

    
    init(interface: TopStoriesListViewProtocol, interactor: TopStoriesListInteractorInputProtocol?, listImageLoadingInteractor: ListImageDataLoadingInteractorProtocol?, router: TopStoriesListWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.listImageLoadingInteractor = listImageLoadingInteractor
        self.router = router
    }
    
    func viewLoaded() {
        
        view?.displayLoader(true)
        interactor?.getTopStoriesList(for: selectedSection)
    }
    
    func loadImages(for indexs: [Int]) {
        for index in indexs {
            if let URL = topStories[index].imageURL {
                self.listImageLoadingInteractor?.loadImageData(at: index, for: URL)
            }
        }
    }
    
    func cancelLoads(for indexs: [Int]) {
        for index in indexs {
            self.listImageLoadingInteractor?.cancelLoad(at: index)
        }
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
        view?.displayTopStories()
    }
    
    func presentError(_ error: TopStoryServiceError) {
        stopsLoaderAndDisplayErrorMessage(error.localizedDescription)
    }
    
    private func stopsLoaderAndDisplayErrorMessage(_ message: String) {
        view?.displayLoader(false)
        router.routeToErrorView(with: message)
    }
}

extension TopStoriesListPresenter: ListImageDataLoadingOutputProtocol {
    
    func presentImageData(at index: Int, having url: URL, with data: Data) {
        if index < topStories.count {
            var viewModel = self.topStories[index]
            viewModel.imgData = data
            self.topStories[index] = viewModel
            self.view?.updateCell(at: index, with: viewModel)
        }
    }
    
    func presentError(_ errMsg: String) {
        stopsLoaderAndDisplayErrorMessage(errMsg)
    }
}
