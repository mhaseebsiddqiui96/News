//
//  TopStoryDetailViewControllerTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/9/22.
//

import XCTest
@testable import TopStories

class TopStoryDetailViewControllerTest: XCTestCase {

    
    func test_viewDidLoad_performsInitialSetup() throws {
        let view = TopStoryDetailView()
        let viewController = TopStoryDetailViewController(interface: view)
        let presenter = PresenterSpy()
        presenter.title = "Hello"
        viewController.presenter = presenter
        _ = viewController.view
        
        XCTAssertEqual(viewController.title, "Hello")
        XCTAssertEqual(1, presenter.viewLoadedCalled)
        
    }
    
    func test_seeMoreTap_notifiesPresenter() throws {
        let view = TopStoryDetailView()
        let viewController = TopStoryDetailViewController(interface: view)
        let presenter = PresenterSpy()
        viewController.presenter = presenter
        _ = viewController.view
        
    
        view.seeMoreBtnTapped()
    
        XCTAssertEqual(presenter.seeMoreTappedCalled, 1)
        
    }
    
    

    // MARK: - Helper
    class PresenterSpy: TopStoryDetailPresenterProtocol {
        
        var interactor: TopStoryDetailInteractorInputProtocol?
        var viewLoadedCalled = 0
        var seeMoreTappedCalled = 0
        
        var title: String = ""
        
        func viewLoaded() {
            viewLoadedCalled += 1
        }
        
        func seeMoreTapped() {
            seeMoreTappedCalled += 1
        }
    }
    
}
