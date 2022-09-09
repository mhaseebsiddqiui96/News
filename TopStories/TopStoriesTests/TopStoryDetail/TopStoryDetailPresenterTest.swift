//
//  TopStoryDetailPresenterTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import XCTest
@testable import TopStories

class TopStoryDetailPresenterTest: XCTestCase {
    
    func test_presentStoryDetail_notifiesViewWithListOfViewModels() throws {
        let (view, _, _, sut) = makeSUT()
       
        let entity = getEntity()
        
        sut.presentStoryDetails(entity)
        
        XCTAssertEqual(view.displayStoryDetailViewModel.count, 1)
        XCTAssertEqual(view.displayStoryDetailViewModel[0].author, "by haseeb")
        XCTAssertEqual(view.displayStoryDetailViewModel[0].title, "title1")
        XCTAssertEqual(view.displayStoryDetailViewModel[0].description, "abstract1")
        XCTAssertEqual(view.displayStoryDetailViewModel[0].url, URL(string: "https://some-url.com"))
        XCTAssertNotNil(sut.storyDetailViewModel)
    }
    
    func test_viewLoaded_notifierInteractorToGetStoryDetails() {
        let (_, interactor, _, presenter) = makeSUT()
        presenter.viewLoaded()
        
        XCTAssertEqual(interactor.getTopStoryDetailsCalled, 1)
    }
        
        func test_presentImageData_notifiesView() throws {
            let (view, _, _, presenter) = makeSUT()
            let anyData = Data()
            
            presenter.storyDetailViewModel = StoryDetailViewModel(form: getEntity())
            
            
            presenter.presentImageData(anyData)
            
            XCTAssertEqual(presenter.storyDetailViewModel?.imgData, anyData)
            XCTAssertEqual(view.imgeData, [anyData])
        }
    
    
    func test_seeMoreTapped_routeToSeeMore() throws {
        let (_, _, router, presenter) = makeSUT()
        presenter.storyDetailViewModel = StoryDetailViewModel(form: getEntity())
        
        
        presenter.seeMoreTapped()
        
        XCTAssertEqual(router.routeToSeemWithURL, [URL(string: "https://some-url.com")])
    }


    //MARK: - Helpers
    class DetailViewSpy: TopStoryDetailViewProtocol {
       
        var presenter: TopStoryDetailPresenterProtocol?
        var displayStoryDetailViewModel = [StoryDetailViewModel]()
        var imgeData = [Data]()
       
        func displayStoryDetails(_ viewModel: StoryDetailViewModel) {
            displayStoryDetailViewModel.append(viewModel)
        }
        
        func displayImage(_ data: Data) {
            imgeData.append(data)
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
        var routeToSeemWithURL = [URL]()
        func routeToSeeMore(with URL: URL) {
            routeToSeemWithURL.append(URL)
        }
        
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
    
            fileprivate func getEntity() -> StoryItem {
                return StoryItem(id: UUID(), title: "title1", abstract: "abstract1", url: "https://some-url.com", byline: "by haseeb", multimedia: [StoryItem.Multimedia(url: "https://some-url.com", format: .superJumbo)])
            }
            


}
