//
//  TopStoryDetailRouter.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.

import UIKit

class TopStoryDetailRouter: TopStoryDetailWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule(_ entity: StoryItem) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = TopStoryDetailViewController()
        let interactor = TopStoryDetailInteractor(entity)
        let router = TopStoryDetailRouter()
        let presenter = TopStoryDetailPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
