//
//  TopStoriesListViewController.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import UIKit

class TopStoriesListViewController: UIViewController {

    let userInterface: TopStoriesListInterfaceView
    var presenter: TopStoriesListPresenterProtocol?
    
    init(interface: TopStoriesListInterfaceView) {
        userInterface = interface
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = userInterface
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewLoaded()
    }
    
    private func setupUI() {
        self.title = presenter?.title
        userInterface.setDelegate(self)
        userInterface.setDataSource(self)
    }

}

//MARK: - Preenter -> View
extension TopStoriesListViewController: TopStoriesListViewProtocol {
    
    func displayTopStories(_ viewModel: [StoryItemViewModel]) {
        userInterface.reloadListOfStories()
    }
    
    func displayErrorMessage(_ message: String) {
        
    }
    
    func displayLoader(_ show: Bool) {
        userInterface.showActivityIndicator(show)
    }
    
}

//MARK: - TableView DataSoruce and Delegate
extension TopStoriesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.topStories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(TopStoryCell.self)",
            for: indexPath
        ) as? TopStoryCell else { return UITableViewCell() }
        
        guard let viewModel = presenter?.topStories[indexPath.row] else { return UITableViewCell() }
        cell.populate(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = presenter?.topStories[indexPath.row] else { return  }
        viewModel.didTap()
    }
}
