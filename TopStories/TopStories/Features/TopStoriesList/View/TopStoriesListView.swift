//
//  TopStoriesListView.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import UIKit

typealias TopStoriesListInterfaceView = TopStoriesListInterface & UIView

protocol TopStoriesListInterface: AnyObject {
    func showActivityIndicator(_ show: Bool)
    func setDataSource(_ source: UITableViewDataSource)
    func setDelegate(_ source: UITableViewDelegate)
    func reloadListOfStories()
}

class TopStoriesListView: UIView, TopStoriesListInterface {

    // views
    let tableViewStories: UITableView = {
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
    
    func setDataSource(_ source: UITableViewDataSource) {
        tableViewStories.dataSource = source
    }
    
    func setDelegate(_ source: UITableViewDelegate) {
        tableViewStories.delegate = source
    }

    func reloadListOfStories() {
        DispatchQueue.main.async {
            self.tableViewStories.reloadData()
        }
    }
    
    
    func addAcitivityIndicator() {
        activityView = UIActivityIndicatorView()
        
        addSubview(activityView)
        activityView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([activityView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     activityView.centerYAnchor.constraint(equalTo: centerYAnchor)])

    }
    
    func showActivityIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.activityView?.startAnimating()
            } else {
                self.activityView?.stopAnimating()
            }
        }
        
    }

}
