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
        
        let httpClient = URLSessionClient()
        let service = TopStoriesService(
            client: httpClient
        )
        
        let interactor = TopStoriesListInteractor(service: service)
        
        let listImageLoading = ListImageDataLoadingInteractor(
            interactor: CachedImageLoadingService(
                dataStore: InMemoryImageDataStore(),
                serivce: ImageLoaderSerivce(client: httpClient)
            )
        )
        
        let router = TopStoriesListRouter()
        let presenter = TopStoriesListPresenter(interface: view, interactor: interactor, listImageLoadingInteractor: listImageLoading, router: router)

        viewController.presenter = presenter
        interactor.presenter = presenter
        listImageLoading.presenter = presenter
        router.viewController = viewController

        return viewController
    }
    
    func routeToStoryDetail(with entitiy: StoryItem) {
        viewController?.navigationController?.pushViewController(TopStoryDetailRouter.createModule(entitiy), animated: true)
    }
    
}
