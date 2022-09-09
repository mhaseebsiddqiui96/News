//
//  TopStoryDetailProtocols.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.


import Foundation

// MARK: Wireframe -
protocol TopStoryDetailWireframeProtocol: AnyObject {
    func routeToSeeMore(with URL: URL)
}
// MARK: Presenter -
protocol TopStoryDetailPresenterProtocol: AnyObject {

    var interactor: TopStoryDetailInteractorInputProtocol? { get set }
    var title: String {get set}
    func viewLoaded()
    func seeMoreTapped()
}

// MARK: Interactor -
protocol TopStoryDetailInteractorOutputProtocol: AnyObject {

    /* Interactor -> Presenter */
    func presentStoryDetails(_ entity: StoryItem)
    func presentImageData(_ data: Data)
}

protocol TopStoryDetailInteractorInputProtocol: AnyObject {

    var presenter: TopStoryDetailInteractorOutputProtocol? { get set }

    /* Presenter -> Interactor */
    func getTopStoryDetail()
}

// MARK: View -
protocol TopStoryDetailViewProtocol: AnyObject {

    /* Presenter -> ViewController */
    func displayStoryDetails(_ viewModel: StoryDetailViewModel)
    func displayImage(_ data: Data)
}
