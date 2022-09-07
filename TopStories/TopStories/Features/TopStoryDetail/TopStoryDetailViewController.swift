//
//  TopStoryDetailViewController.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.


import UIKit

class TopStoryDetailViewController: UIViewController {

	var presenter: TopStoryDetailPresenterProtocol?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    
}

extension TopStoryDetailViewController: TopStoryDetailViewProtocol {
    func displayStoryDetails(_ viewModel: StoryDetailViewModel) {
        
    }
}
