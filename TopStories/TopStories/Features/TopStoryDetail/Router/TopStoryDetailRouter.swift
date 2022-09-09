//
//  TopStoryDetailRouter.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.

import UIKit
import SafariServices

class TopStoryDetailRouter: TopStoryDetailWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule(_ entity: StoryItem) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let interface = TopStoryDetailView()
        let view = TopStoryDetailViewController(interface: interface)
        
        
        let service = CachedImageLoadingService(
                dataStore: InMemoryImageDataStore(),
                serivce: ImageLoaderSerivce(client: URLSessionClient())
            )
        
        let interactor = TopStoryDetailInteractor(entity, service: service)
        let router = TopStoryDetailRouter()
        let presenter = TopStoryDetailPresenter(interface: interface, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
    
    func routeToSeeMore(with URL: URL) {
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: URL, configuration: config)
        viewController?.present(vc, animated: true)
        
    }
}
