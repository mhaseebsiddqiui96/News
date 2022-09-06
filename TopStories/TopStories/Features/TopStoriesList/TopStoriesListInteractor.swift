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
        service.fetch {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                break
            case .failure(let err):
                self.handleFailure(with: err)
            }
        }
    }
    
    private func handleFailure(with error: TopStoryServiceError) {
        switch error {
            
       
        case .internetConnectivity:
            self.presenter?.presentConnectivityError()
        case .unAuthorized:
            break
        case .invalidData:
            self.presenter?.presentInvalidDataError()
        }

    }

}
