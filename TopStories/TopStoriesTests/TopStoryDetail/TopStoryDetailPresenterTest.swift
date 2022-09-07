//
//  TopStoryDetailPresenterTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import XCTest
@testable import TopStories

class TopStoryDetailPresenterTest: XCTestCase {
    
    func test_presentListOfStories_notifiesViewWithListOfViewModels() throws {
        let (view, _, _, sut) = makeSUT()
       
        let entity = StoryItem(id: UUID(), section: "section1", subsection: "subsection1", title: "title1", abstract: "abstract1", url: "https://some-url.com", uri: nil, byline: "by haseeb", itemType: nil, updatedDate: Date(), createdDate: Date(), publishedDate: Date(), multimedia: nil)
        
        sut.presentStoryDetails(entity)
        
        XCTAssertEqual(view.displayStoryDetailViewModel.count, 1)
        XCTAssertEqual(view.displayStoryDetailViewModel[0].author, "by haseeb")
        XCTAssertEqual(view.displayStoryDetailViewModel[0].title, "title1")
        XCTAssertEqual(view.displayStoryDetailViewModel[0].description, "abstract1")
        XCTAssertEqual(view.displayStoryDetailViewModel[0].url, URL(string: "https://some-url.com"))
   }
    
    
    func test_viewLoaded_notifierInteractorToGetStoryDetails() {
        let (_, interactor, _, presenter) = makeSUT()
        presenter.viewLoaded()
        
        XCTAssertEqual(interactor.getTopStoryDetailsCalled, 1)
    }


    //MARK: - Helpers
    class DetailViewSpy: TopStoryDetailViewProtocol {
       
        var presenter: TopStoryDetailPresenterProtocol?
        var displayStoryDetailViewModel = [StoryDetailViewModel]()
       
        func displayStoryDetails(_ viewModel: StoryDetailViewModel) {
            displayStoryDetailViewModel.append(viewModel)
        }
    }
    
    class DetailViewInteractorSpy: TopStoryDetailInteractorInputProtocol {
        var presenter: TopStoryDetailInteractorOutputProtocol?
        var getTopStoryDetailsCalled = 0
        
        func getTopStoryDetail() {
            getTopStoryDetailsCalled += 1
        }
    }
    
    class RouterSpy: TopStoryDetailWireframeProtocol {
        
    }
    
    
    func makeSUT() -> (view: DetailViewSpy, interactor: DetailViewInteractorSpy, router: RouterSpy, presenter: TopStoryDetailPresenter) {
        let view = DetailViewSpy()
        let interactor = DetailViewInteractorSpy()
        let router = RouterSpy()
        let presenter = TopStoryDetailPresenter(interface: view,
                                                interactor: interactor,
                                                router: router)
        return (view, interactor, router, presenter)
    }
    


}
