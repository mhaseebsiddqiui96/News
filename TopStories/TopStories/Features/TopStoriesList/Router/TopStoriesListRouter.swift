//
//  TopStoriesListRouter.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import UIKit

class TopStoriesListRouter: TopStoriesListWireframeProtocol {
    
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        //let view = ProductsListView()
        let view = TopStoriesListView()
        let viewController = TopStoriesListViewController(interface: view)
        
        let service = TopStoriesService(
            client: URLSessionClient(),
            urlRequest: TopStoriesEndPoint.getTopStories(for: "home").asURLRequest()
        )
        
        let interactor = TopStoriesListInteractor(service: service)
        
        let router = TopStoriesListRouter()
        let presenter = TopStoriesListPresenter(interface: viewController, interactor: interactor, router: router)

        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController

        return viewController
    }
    
    func routeToStoryDetail(with entitiy: StoryItem) {
        viewController?.navigationController?.pushViewController(TopStoryDetailRouter.createModule(entitiy), animated: true)
    }
    
}
