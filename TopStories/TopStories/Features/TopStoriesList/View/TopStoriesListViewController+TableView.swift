//
//  TopStoriesListViewController+TableView.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import UIKit

//MARK: - TableView DataSoruce and Delegate
extension TopStoriesListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.topStories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TopStoryCell.self)", for: indexPath) as? TopStoryCell else { return UITableViewCell() }
        
        guard let viewModel = presenter?.topStories[indexPath.row] else { return UITableViewCell() }
        cell.populate(with: viewModel)
        cell.onPrepareToReUse = { [weak self] in
            self?.presenter?.cancelLoads(for: [indexPath.row])
        }
        presenter?.loadImages(for: [indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = presenter?.topStories[indexPath.row] else { return  }
        viewModel.didTap()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        presenter?.loadImages(for: indexPaths.map({$0.row}))
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        presenter?.cancelLoads(for: indexPaths.map({$0.row}))
        
    }
}
