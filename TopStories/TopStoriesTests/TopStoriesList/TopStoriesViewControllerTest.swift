//
//  TopStoriesViewControllerTest.swift
//  TopStoriesTests
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import XCTest
@testable import TopStories

class TopStoriesViewControllerTest: XCTestCase {

    func test_viewDidLoad_performInitialSetup() throws {
        
        let (view, presenter, sut) = makeSUT()
        presenter.title = "Something"
        _ = sut.view
        
        XCTAssertEqual(sut.title, "Something")
        XCTAssertEqual(presenter.viewLoeadedCalledCount, 1)
        XCTAssertEqual(view.dataSources.count, 1)
        XCTAssertEqual(view.delegates.count, 1)
    }
    
    func test_displayListOfStories_notifiesViewToReloadData() throws {
        let (view, _ , sut) = makeSUT()
        _ = sut.view
        view.displayTopStories([])
        XCTAssertEqual(view.reloadStoriesCalledCount, 1)
    }
    
    func test_displayLoader_notifiesView() throws {
        let (view, _ , sut) = makeSUT()
        _ = sut.view
        view.displayLoader(true)
        XCTAssertEqual(view.activityIndicator, [true])
        
        view.activityIndicator.removeAll()
        view.displayLoader(false)
        XCTAssertEqual(view.activityIndicator, [false])
    }
    
    func test_displayListOfStories_rendersDataOnCell() throws {
        let (view, presenter, sut) = makeSUT()
        _ = sut.view
        presenter.topStories = [
            StoryItemViewModel(imageURL: URL(string: "https://some-url1.com")!, title: "title1", author: "author1", didTap: {}),
            StoryItemViewModel(imageURL: URL(string: "https://some-url2.com")!, title: "title2", author: "author2", didTap: {})
        ]

        view.displayTopStories([])
        XCTAssertEqual(view.tableViewStories.numberOfCells(), 2)
        XCTAssertEqual(view.tableViewStories.cell(for: 0)?.storyTitleLabel.text, "title1")
        XCTAssertEqual(view.tableViewStories.cell(for: 0)?.storyAuthorLabel.text, "author1")
    }
    
    func test_didSelectCell_callsViewModelDidTap() throws {
        let (view, presenter, sut) = makeSUT()
        _ = sut.view
        
        var didTapForViewModel = ""
        presenter.topStories = [
            StoryItemViewModel(imageURL: URL(string: "https://some-url1.com")!, title: "title1", author: "author1", didTap: {didTapForViewModel = "vm1"}),
            StoryItemViewModel(imageURL: URL(string: "https://some-url2.com")!, title: "title2", author: "author2", didTap: {didTapForViewModel = "vm2"})
        ]

        view.displayTopStories([])
        
        view.tableViewStories.didSelectRow(at: 0)
        XCTAssertEqual(didTapForViewModel, "vm1")
        
        view.tableViewStories.didSelectRow(at: 1)
        XCTAssertEqual(didTapForViewModel, "vm2")
    }

        
    //MARK: - Helpers
    class TopStoriesListViewSpy: TopStoriesListView {
    
        

        var dataSources = [UITableViewDataSource & UITableViewDataSourcePrefetching]()
        var delegates = [UITableViewDelegate]()
        var reloadStoriesCalledCount = 0
        var activityIndicator: [Bool] = []


        override func displayLoader(_ show: Bool) {
            activityIndicator.append(show)
        }

        override func displayTopStories(_ viewModel: [StoryItemViewModel]) {
            super.displayTopStories(viewModel)
            reloadStoriesCalledCount += 1
        }
        
        override func displayErrorMessage(_ message: String) {
            
        }
        
        override func updateCell(at index: Int, with viewModel: StoryItemViewModel) {
            
        }
        
        override func setDelegate(_ source: UITableViewDelegate) {
            super.setDelegate(source)
            delegates.append(source)
        }
        
        override func setDataSource(_ source: UITableViewDataSource & UITableViewDataSourcePrefetching) {
            super.setDataSource(source)
            self.dataSources.append(source)
        }

    }
    
    
    class PresenterSpy: TopStoriesListPresenterProtocol {
        
        
        var viewLoeadedCalledCount = 0

        var interactor: TopStoriesListInteractorInputProtocol?
        
        var title: String = ""
        
        var topStories: [StoryItemViewModel] = []
        
        func viewLoaded() {
            viewLoeadedCalledCount += 1
        }
        
        func loadImages(for indexs: [Int]) {
            
        }
        
        func cancelLoads(for indexs: [Int]) {
            
        }
        
    }
    
    func makeSUT() -> (view: TopStoriesListViewSpy, presenter: PresenterSpy, controller: TopStoriesListViewController) {
        let view = TopStoriesListViewSpy()
        let sut = TopStoriesListViewController(interface: view)
        let presenter = PresenterSpy()
        sut.presenter = presenter
        return (view, presenter, sut)
    }
    
}

extension UITableView {
    func numberOfCells() -> Int {
        return self.dataSource?.tableView(self, numberOfRowsInSection: 0) ?? 0
    }
    
    func cell(for row: Int) -> TopStoryCell? {
        return self.dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0)) as? TopStoryCell
    }
    
    func didSelectRow(at index: Int) {
        self.delegate?.tableView?(self, didSelectRowAt: IndexPath(row: index, section: 0))
    }
}
