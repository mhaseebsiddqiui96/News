//
//  TopStoriesListInteractor.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/6/22.
//

import Foundation

class TopStoriesListInteractor: TopStoriesListInteractorInputProtocol {
    
    var presenter: TopStoriesListInteractorOutputProtocol?
    private let service: TopStoriesServiceProtocol
    
    init(service: TopStoriesServiceProtocol) {
        self.service = service
    }
    
    func getTopStoriesList(for section: String) {
        let urlRequest = TopStoriesEndPoint.getTopStories(for: section).asURLRequest()
        service.fetch(urlRequest: urlRequest) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let stories):
                self.presenter?.presentListOfStories(stories)
            case .failure(let err):
                self.presenter?.presentError(err)
            }
        }
        
    }
}
