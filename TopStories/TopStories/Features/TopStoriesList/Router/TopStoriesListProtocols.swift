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
    func presentError(_ error: TopStoryServiceError)

}

protocol ListImageDataLoadingOutputProtocol: AnyObject {
    func presentImageData(at index: Int, having url: URL, with data: Data)
    func presentError(_ errMsg: String)
}

protocol TopStoriesListInteractorInputProtocol: AnyObject {

    var presenter: TopStoriesListInteractorOutputProtocol? { get set }

    /* Presenter -> Interactor */
    func getTopStoriesList(for section: String)
}


// MARK: Presenter -
protocol TopStoriesListPresenterProtocol: AnyObject {

    var interactor: TopStoriesListInteractorInputProtocol? { get set }
    var title: String { get }
    var topStories: [StoryItemViewModel] { get set }
    
    func viewLoaded()
    func loadImages(for indexs: [Int])
    func cancelLoads(for indexs: [Int])
}

// MARK: View -
protocol TopStoriesListViewProtocol: AnyObject {
    
    /* Presenter -> ViewController */
    func displayTopStories(_ viewModel: [StoryItemViewModel])
    func displayErrorMessage(_ message: String)
    func displayLoader(_ show: Bool)
    
    func updateCell(at index: Int, with viewModel: StoryItemViewModel)
}
