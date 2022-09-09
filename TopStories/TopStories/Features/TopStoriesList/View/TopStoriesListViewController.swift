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

