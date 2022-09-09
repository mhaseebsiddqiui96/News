//
//  TopStoryDetailViewController.swift
//  TopStories
//
//  Created Muhammad Haseeb Siddiqui on 9/8/22.


import UIKit

class TopStoryDetailViewController: UIViewController {

	var presenter: TopStoryDetailPresenterProtocol?
    let userInterface: TopStoryDetailInterfaceView

    init(interface: TopStoryDetailInterfaceView) {
        self.userInterface = interface
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
        presenter?.viewLoaded()
        setupUI()
        listenEventsFromView()
    }
    
    fileprivate func setupUI() {
        self.title = presenter?.title ?? "--"
    }
    
    fileprivate func listenEventsFromView() {
        userInterface.seeMoreTapped = {[weak self] in
            self?.presenter?.seeMoreTapped()
        }
    }
    
    
}
