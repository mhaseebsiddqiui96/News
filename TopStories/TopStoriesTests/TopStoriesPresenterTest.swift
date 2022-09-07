//
//  TopStoriesPresentTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import XCTest
@testable import TopStories

class TopStoriesPresentTest: XCTestCase {

    func test_presentListOfStories_notifiesViewWithListOfViewModels() throws {
        let (view, _, _, presenter) = makeSUT()
        
        let stories = getDummyStories()
        
        presenter.presentListOfStories(stories)
        XCTAssertEqual(view.listOfStoriesViewModel, [
            StoryItemViewModel(imageURL: URL(string: "https://some-url2.com")!, title: "StoryTitle1", author: "by Siddiqui", didTap: {}),
            StoryItemViewModel(imageURL: URL(string: "https://some-url.com")!, title: "StoryTitle2", author: "by Haseeb", didTap: {})
        ])
        
        XCTAssertEqual(view.displayLoader, [false])
        
    }
    
    
    func test_viewModelSelection_notifiesRouterWithEntity() throws {
        let (view, _, router, presenter) = makeSUT()
        
        let stories = getDummyStories()
        
        presenter.presentListOfStories(stories)
        
        view.listOfStoriesViewModel[0].didTap()
       
        XCTAssertEqual(router.entities, [stories[0]])
        
    }
    
    func test_presentInvalidDataError_notifiesViewWithErrorMessage() throws {
        let (view, _, _, presenter) = makeSUT()

        presenter.presentError(.invalidData)
        XCTAssertEqual(view.displayErrorMessage, [TopStoryServiceError.invalidData.localizedDescription])
        XCTAssertEqual(view.displayLoader, [false])

    }

    func test_presentConnctivityError_notifiesViewWithErrorMessage() throws {
        let (view, _, _, presenter) = makeSUT()

        presenter.presentError(.internetConnectivity)
        XCTAssertEqual(view.displayErrorMessage, [TopStoryServiceError.internetConnectivity.localizedDescription])
        XCTAssertEqual(view.displayLoader, [false])

    }

    func test_presentAuthError_notifiesViewWithErrorMessage() throws {
        let (view, _, _, presenter) = makeSUT()

        presenter.presentError(.unAuthorized)
        XCTAssertEqual(view.displayErrorMessage, [TopStoryServiceError.unAuthorized.localizedDescription])
        XCTAssertEqual(view.displayLoader, [false])

    }
    
    func test_viewLoaded_notifierViewForLoaderAndInteractorToGetStories() {
        let (view, interactor, _, presenter) = makeSUT()
        presenter.viewLoaded()
        
        XCTAssertEqual(view.displayLoader, [true])
        XCTAssertEqual(interactor.getTopStoriesList, [presenter.selectedSection])
    }

    //MARK: - Helpers
    class TopStoriesListViewSpy: TopStoriesListViewProtocol {
     
        var presenter: TopStoriesListPresenterProtocol?
        var listOfStoriesViewModel: [StoryItemViewModel] = []
        var displayErrorMessage: [String] = []
        var displayLoader: [Bool] = []
        
        
        func displayTopStories(_ viewModel: [StoryItemViewModel]) {
            listOfStoriesViewModel.append(contentsOf: viewModel)
        }
        
        func displayErrorMessage(_ message: String) {
            displayErrorMessage.append(message)
        }
        
        func displayLoader(_ show: Bool) {
            displayLoader.append(show)
        }
        
    }
    
    class TopStoriesListInteractorSpy: TopStoriesListInteractorInputProtocol {
        var presenter: TopStoriesListInteractorOutputProtocol?
        var getTopStoriesList: [String] = []
        
        func getTopStoriesList(for section: String) {
            getTopStoriesList.append(section)
        }
    }
    
    class TopStoriesListRouterSpy: TopStoriesListWireframeProtocol {
        
        var entities: [StoryItem] = []
        
        func routeToStoryDetail(with entitiy: StoryItem) {
            entities.append(entitiy)
        }
    }
    
    func makeSUT() -> (view: TopStoriesListViewSpy, interactor: TopStoriesListInteractorSpy, router: TopStoriesListRouterSpy, presenter: TopStoriesListPresenter) {
        let view = TopStoriesListViewSpy()
        let interactor = TopStoriesListInteractorSpy()
        let router = TopStoriesListRouterSpy()
        let presenter = TopStoriesListPresenter(interface: view,
                                                interactor: interactor,
                                                router: router)
        return (view, interactor, router, presenter)
    }
    
    func getDummyStories() -> [StoryItem] {
        let stories = [
            StoryItem(id: UUID(), section: "Home1", subsection: "Something1", title: "StoryTitle1", abstract: nil, url: nil, uri: nil, byline: "by Siddiqui", itemType: nil, updatedDate: nil, createdDate: nil, publishedDate: nil, materialTypeFacet: nil, kicker: nil, desFacet: nil, orgFacet: nil, perFacet: nil, geoFacet: nil, multimedia: [StoryItem.Multimedia(url: "https://some-url2.com", format: .largeThumbnail, height: 300, width: 300, type: nil, subtype: nil, caption: nil, copyright: nil)], shortURL: nil),
            
            StoryItem(id: UUID(), section: "Home2", subsection: "Something2", title: "StoryTitle2", abstract: nil, url: nil, uri: nil, byline: "by Haseeb", itemType: nil, updatedDate: nil, createdDate: nil, publishedDate: nil, materialTypeFacet: nil, kicker: nil, desFacet: nil, orgFacet: nil, perFacet: nil, geoFacet: nil, multimedia: [StoryItem.Multimedia(url: "https://some-url.com", format: .largeThumbnail, height: 300, width: 300, type: nil, subtype: nil, caption: nil, copyright: nil)], shortURL: nil)
        ]
        
        return stories
    }

}
