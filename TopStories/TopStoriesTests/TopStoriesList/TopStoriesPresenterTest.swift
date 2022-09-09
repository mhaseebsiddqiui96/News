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
    
    func test_loadImageForIndexs_notifiesIneractorToLoadImages() throws {
        let (_, _, interactor, _, presenter) = makeSUT()
        
        presenter.topStories = [
            StoryItemViewModel(imageURL: URL(string: "https://some-url2.com")!, title: "StoryTitle1", author: "by Siddiqui", didTap: {}),
            StoryItemViewModel(imageURL: URL(string: "https://some-url.com")!, title: "StoryTitle2", author: "by Haseeb", didTap: {})
        ]
        presenter.loadImages(for: [0, 1])
        
        XCTAssertEqual(interactor.loadImageCalled[0], URL(string: "https://some-url2.com")!)
        XCTAssertEqual(interactor.loadImageCalled[1], URL(string: "https://some-url.com")!)
        
        presenter.loadImages(for: [2]) // safe check to see app dont crash
        XCTAssertNil(interactor.loadImageCalled[2])

    }
    
    func test_CancelImageLoadForIndexs_notifiesIneractorToCancelLoad() throws {
        let (_, _, interactor, _, presenter) = makeSUT()
        
        presenter.topStories = [
            StoryItemViewModel(imageURL: URL(string: "https://some-url2.com")!, title: "StoryTitle1", author: "by Siddiqui", didTap: {}),
            StoryItemViewModel(imageURL: URL(string: "https://some-url.com")!, title: "StoryTitle2", author: "by Haseeb", didTap: {})
        ]
        presenter.cancelLoads(for: [0, 1])
        
        XCTAssertEqual(interactor.cancenlImageCalled, [0, 1])

    }
    
    func test_presentImageData_notifiesViewToUpdateCell() throws {
        let (view, _, _, _, presenter) = makeSUT()

        let url = URL(string: "https://some-url.com")!
        presenter.topStories = [StoryItemViewModel(imageURL: url, title: "title1", author: "author1", imgData: nil, didTap: {})]
        
        let anyData = Data()
        presenter.presentImageData(at: 0, having: url, with: anyData)
        
        var expectedViewModel = presenter.topStories[0]
        expectedViewModel.imgData = anyData
        
        XCTAssertEqual(view.updateCellsCalled[0], expectedViewModel)
        
        presenter.presentImageData(at: 1, having: url, with: anyData)
        XCTAssertNil(view.updateCellsCalled[1]) // safe checking for crash index bound
    }
    
    func test_presentImageData_updatesItsOwnViewModel() throws {
        let (_, _, _, _, presenter) = makeSUT()

        let url = URL(string: "https://some-url.com")!
        presenter.topStories = [StoryItemViewModel(imageURL: url, title: "title1", author: "author1", imgData: nil, didTap: {})]
        
        let anyData = Data()
        presenter.presentImageData(at: 0, having: url, with: anyData)
       
        XCTAssertEqual(presenter.topStories[0].imgData, anyData)
        
        presenter.presentImageData(at: 1, having: url, with: anyData) // to make app crash in test if somehow condition is missed on presenter

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
        var updateCellsCalled = [Int: StoryItemViewModel]()
        
        
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
            updateCellsCalled[index] = viewModel
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
        
        var loadImageCalled = [Int: URL]()
        var cancenlImageCalled = [Int]()
        
        func loadImageData(at index: Int, for url: URL) {
            loadImageCalled[index] = url
        }
        
        func cancelLoad(at index: Int) {
            cancenlImageCalled.append(index)
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
            StoryItem(id: UUID(), title: "StoryTitle1", abstract: "something", url: nil, byline: "by Siddiqui", multimedia: [StoryItem.Multimedia(url: "https://some-url2.com", format: .largeThumbnail)]),
            
            StoryItem(id: UUID(), title: "StoryTitle2", abstract: "some", url: nil, byline: "by Haseeb", multimedia: [StoryItem.Multimedia(url: "https://some-url.com", format: .largeThumbnail)])
        ]
        
        return stories
    }

}
