//
//  TopStoriesListView.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import UIKit

typealias TopStoriesListInterfaceView = TopStoriesListInterface & UIView

protocol TopStoriesListInterface: AnyObject {
    func setDataSource(_ source: UITableViewDataSource & UITableViewDataSourcePrefetching)
    func setDelegate(_ source: UITableViewDelegate)
}

class TopStoriesListView: UIView, TopStoriesListInterface, TopStoriesListViewProtocol {

    // views
    lazy var tableViewStories: UITableView = {
        let tableView = UITableView()
        tableView.register(TopStoryCell.self, forCellReuseIdentifier: "\(TopStoryCell.self)")
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    var activityView: UIActivityIndicatorView!
    
    init() {
        super.init(frame: .zero)
        addStoriesTableView()
        addAcitivityIndicator()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    private func addStoriesTableView() {
        addSubviewAndPinEdges(tableViewStories)
    }
    
    func setDataSource(_ source: UITableViewDataSource & UITableViewDataSourcePrefetching) {
        tableViewStories.dataSource = source
        tableViewStories.prefetchDataSource = source
    }
    
    func setDelegate(_ source: UITableViewDelegate) {
        tableViewStories.delegate = source
    }

    
    
    
    func addAcitivityIndicator() {
        activityView = UIActivityIndicatorView()
        
        addSubview(activityView)
        activityView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([activityView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     activityView.centerYAnchor.constraint(equalTo: centerYAnchor)])

    }

    //Presenter -> View
    func displayTopStories() {
        DispatchQueue.main.async {
            self.tableViewStories.reloadData()
        }
    }
    
    func displayLoader(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.activityView?.startAnimating()
            } else {
                self.activityView?.stopAnimating()
            }
        }
    }
    
    func updateCell(at index: Int, with viewModel: StoryItemViewModel) {
        DispatchQueue.main.async {
            if let cell = self.tableViewStories.cellForRow(at: IndexPath(row: index, section: 0)) as? TopStoryCell {
                cell.populate(with: viewModel)
            }
        }
    }
}
