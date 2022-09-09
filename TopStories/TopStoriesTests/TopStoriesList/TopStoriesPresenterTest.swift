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
        let (view, _, _ , _, presenter) = makeSUT()
        
        let stories = getDummyStories()
        
        presenter.presentListOfStories(stories)
        
        XCTAssertEqual(view.displayTopStoriesCalledCount, 1)
        XCTAssertEqual(presenter.topStories, [
            StoryItemViewModel(imageURL: URL(string: "https://some-url2.com")!, title: "StoryTitle1", author: "by Siddiqui", didTap: {}),
            StoryItemViewModel(imageURL: URL(string: "https://some-url.com")!, title: "StoryTitle2", author: "by Haseeb", didTap: {})
        ])
        XCTAssertEqual(view.displayLoader, [false])
        
    }
    
    
    func test_viewModelSelection_notifiesRouterWithEntity() throws {
        let (_, _, _, router, presenter) = makeSUT()
        
        let stories = getDummyStories()
        
        presenter.presentListOfStories(stories)
        presenter.topStories[0].didTap()
       
        XCTAssertEqual(router.entities, [stories[0]])
        
    }
    
    func test_presentInvalidDataError_notifiesRouterWithErrorMessage() throws {
        let (view, _, _, router, presenter) = makeSUT()

        presenter.presentError(.invalidData)
        XCTAssertEqual(router.errorView, [TopStoryServiceError.invalidData.localizedDescription])
        XCTAssertEqual(view.displayLoader, [false])

    }

    func test_presentConnctivityError_notifiesRouterWithErrorMessage() throws {
        let (view, _,_, router, presenter) = makeSUT()

        presenter.presentError(.internetConnectivity)
        XCTAssertEqual(router.errorView, [TopStoryServiceError.internetConnectivity.localizedDescription])
        XCTAssertEqual(view.displayLoader, [false])

    }

    func test_presentAuthError_notifiesRouterWithErrorMessage() throws {
        let (view, _, _, router, presenter) = makeSUT()

        presenter.presentError(.unAuthorized)
        XCTAssertEqual(router.errorView, [TopStoryServiceError.unAuthorized.localizedDescription])
        XCTAssertEqual(view.displayLoader, [false])

    }
    
    func test_viewLoaded_notifierViewForLoaderAndInteractorToGetStories() {
        let (view, interactor, _, _, presenter) = makeSUT()
        presenter.viewLoaded()
        
        XCTAssertEqual(view.displayLoader, [true])
        XCTAssertEqual(interactor.getTopStoriesList, [presenter.selectedSection])
    }

    //MARK: - Helpers
    class TopStoriesListViewSpy: TopStoriesListViewProtocol {
       
     
        var presenter: TopStoriesListPresenterProtocol?
        var displayTopStoriesCalledCount = 0
        var displayErrorMessage: [String] = []
        var displayLoader: [Bool] = []
        
        
        func displayTopStories() {
            displayTopStoriesCalledCount += 1
        }
        
        func displayErrorMessage(_ message: String) {
            displayErrorMessage.append(message)
        }
        
        func displayLoader(_ show: Bool) {
            displayLoader.append(show)
        }
        
        func updateCell(at index: Int, with viewModel: StoryItemViewModel) {
            
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
        var errorView: [String] = []
        
        func routeToStoryDetail(with entitiy: StoryItem) {
            entities.append(entitiy)
        }
        
        func routeToErrorView(with message: String) {
            errorView.append(message)
        }
    }
    
    class ListImageDataLoadingSpy: ListImageDataLoadingInteractorProtocol {
        func loadImageData(at index: Int, for url: URL) {
            
        }
        
        func cancelLoad(at index: Int) {
            
        }
        
    }

    
    func makeSUT() -> (view: TopStoriesListViewSpy, interactor: TopStoriesListInteractorSpy, listImageLoadingInteractor: ListImageDataLoadingSpy, router: TopStoriesListRouterSpy, presenter: TopStoriesListPresenter) {
        let view = TopStoriesListViewSpy()
        let interactor = TopStoriesListInteractorSpy()
        let router = TopStoriesListRouterSpy()
        let interactorImageList = ListImageDataLoadingSpy()
        let presenter = TopStoriesListPresenter(interface: view,
                                                interactor: interactor,
                                                listImageLoadingInteractor: interactorImageList,
                                                router: router)
        return (view, interactor, interactorImageList, router, presenter)
    }
    
    func getDummyStories() -> [StoryItem] {
        let stories = [
            StoryItem(id: UUID(), section: "Home1", subsection: "Something1", title: "StoryTitle1", abstract: nil, url: nil, uri: nil, byline: "by Siddiqui", itemType: nil, multimedia: [StoryItem.Multimedia(url: "https://some-url2.com", format: .largeThumbnail, height: 300, width: 300, type: nil, subtype: nil, caption: nil, copyright: nil)]),
            
            StoryItem(id: UUID(), section: "Home2", subsection: "Something2", title: "StoryTitle2", abstract: nil, url: nil, uri: nil, byline: "by Haseeb", itemType: nil, multimedia: [StoryItem.Multimedia(url: "https://some-url.com", format: .largeThumbnail, height: 300, width: 300, type: nil, subtype: nil, caption: nil, copyright: nil)])
        ]
        
        return stories
    }

}
