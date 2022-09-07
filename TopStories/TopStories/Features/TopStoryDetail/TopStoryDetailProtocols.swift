//
//  TopStoryDetailProtocols.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.


import Foundation

// MARK: Wireframe -
protocol TopStoryDetailWireframeProtocol: AnyObject {

}
// MARK: Presenter -
protocol TopStoryDetailPresenterProtocol: AnyObject {

    var interactor: TopStoryDetailInteractorInputProtocol? { get set }
}

// MARK: Interactor -
protocol TopStoryDetailInteractorOutputProtocol: AnyObject {

    /* Interactor -> Presenter */
    func presentStoryDetails(_ entity: StoryItem)
}

protocol TopStoryDetailInteractorInputProtocol: AnyObject {

    var presenter: TopStoryDetailInteractorOutputProtocol? { get set }

    /* Presenter -> Interactor */
    func getTopStoryDetail()
}

// MARK: View -
protocol TopStoryDetailViewProtocol: AnyObject {

    var presenter: TopStoryDetailPresenterProtocol? { get set }

    /* Presenter -> ViewController */
    func displayStoryDetails(_ viewModel: StoryDetailViewModel)
}
