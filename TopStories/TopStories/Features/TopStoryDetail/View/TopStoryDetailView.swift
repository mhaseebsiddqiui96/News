//
//  TopStoryDetailView.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/8/22.
//

import UIKit

typealias TopStoryDetailInterfaceView = TopStoryDetailInterface & UIView

protocol TopStoryDetailInterface: AnyObject {
    var seeMoreTapped: (() -> Void)? {get set}
}


class TopStoryDetailView: TopStoryDetailInterfaceView {
    
    @objc var seeMoreTapped: (() -> Void)?
    
    var potraitBannerWidth: NSLayoutConstraint?
    var landscapeBannerWidth: NSLayoutConstraint?

    var bannerHeight: NSLayoutConstraint?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset.bottom = 32
        return scrollView
    }()
    
    lazy var contentView: UIView = {
          let view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
          return view
      }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Child elements
    lazy var storyBannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var storyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var storyAbstactLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var storyAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        let priority = UILayoutPriority(249)
        label.setContentHuggingPriority(priority, for: .vertical)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    lazy var seeMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("See More", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setupLayout()
        addElementToStackView()
        
        seeMoreButton.addTarget(self, action: #selector(seeMoreBtnTapped), for: .touchUpInside)
    }

    
    private func setupLayout() {
        scrollView.pinEdges(to: self)
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func addElementToStackView() {
        let imgContainerView = UIView()
        imgContainerView.addSubview(storyBannerImageView)
        
        let btnContainerView = UIView()
        btnContainerView.addSubview(seeMoreButton)
        
        NSLayoutConstraint.activate([storyBannerImageView.topAnchor.constraint(equalTo: imgContainerView.topAnchor),
                                     storyBannerImageView.bottomAnchor.constraint(equalTo: imgContainerView.bottomAnchor),
                                     storyBannerImageView.centerXAnchor.constraint(equalTo: imgContainerView.centerXAnchor)])
        
        
        NSLayoutConstraint.activate([seeMoreButton.widthAnchor.constraint(equalTo: btnContainerView.widthAnchor),
                                     seeMoreButton.heightAnchor.constraint(equalToConstant: 50),
                                     seeMoreButton.bottomAnchor.constraint(equalTo: btnContainerView.bottomAnchor),
                                     seeMoreButton.topAnchor.constraint(equalTo: btnContainerView.topAnchor, constant: 32),
                                     seeMoreButton.centerXAnchor.constraint(equalTo: btnContainerView.centerXAnchor)])
        
        stackView.addArrangedSubview(imgContainerView)
        stackView.addArrangedSubview(storyTitleLabel)
        stackView.addArrangedSubview(storyAbstactLabel)
        stackView.addArrangedSubview(storyAuthorLabel)
        stackView.addArrangedSubview(btnContainerView)
        
        
        applyingConstaintBasedViewOrientation(traitCollection: traitCollection)
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyingConstaintBasedViewOrientation(traitCollection: traitCollection)
    }
    
    func applyingConstaintBasedViewOrientation(traitCollection: UITraitCollection) {
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if let landscapeBannerWidth = landscapeBannerWidth, landscapeBannerWidth.isActive {
                NSLayoutConstraint.deactivate([landscapeBannerWidth, bannerHeight ?? NSLayoutConstraint()])
            }
            updateBannerConstaints()
            NSLayoutConstraint.activate([potraitBannerWidth ?? NSLayoutConstraint(), bannerHeight ?? NSLayoutConstraint()])
            
        } else {
            if let potraitBannerWidth = potraitBannerWidth, potraitBannerWidth.isActive {
                   NSLayoutConstraint.deactivate([potraitBannerWidth, bannerHeight ?? NSLayoutConstraint()])
               }
            updateBannerConstaints()
            NSLayoutConstraint.activate([landscapeBannerWidth ?? NSLayoutConstraint(), bannerHeight ?? NSLayoutConstraint()])
        }
    }
    
    func updateBannerConstaints() {
        
        landscapeBannerWidth = storyBannerImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, constant: -40)
        potraitBannerWidth = storyBannerImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        
        let multiplier = traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular ? 1 : 0.5
        bannerHeight = NSLayoutConstraint(item: storyBannerImageView, attribute: .height, relatedBy: .equal, toItem: storyBannerImageView, attribute: .width, multiplier: multiplier, constant: 0)
    }
    
    //MARK: - Events
  
    @objc func seeMoreBtnTapped() {
        self.seeMoreTapped?()
    }
    
}


extension TopStoryDetailView : TopStoryDetailViewProtocol {
    func displayStoryDetails(_ viewModel: StoryDetailViewModel) {
        
        DispatchQueue.main.async {
            self.storyAuthorLabel.text = viewModel.author
            self.storyAbstactLabel.text = viewModel.description
            self.storyTitleLabel.text = viewModel.title
            self.seeMoreButton.isHidden = false
            if let data = viewModel.imgData {
                self.displayImage(data)
            }
        }
    }
    
    func displayImage(_ data: Data) {
        DispatchQueue.main.async {
            if let img = UIImage(data: data) {
                UIView.transition(with: self.storyBannerImageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { self.storyBannerImageView.image = img },
                                  completion: nil)
                
            }
            
        }
        
    }
}
