//
//  TopStoryCell.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/7/22.
//

import UIKit

class TopStoryCell: UITableViewCell {

    let storyThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let storyTitleLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        label.numberOfLines = 0
        return label
    }()
    
    let storyAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        let priority = UILayoutPriority(249)
        label.setContentHuggingPriority(priority, for: .vertical)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    var onPrepareToReUse: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier:  "\(TopStoryCell.self)")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        storyThumbnailImageView.image = nil
        onPrepareToReUse?()
    }

    
    private func setupView() {
        // creating container stack to hold subviews
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        stackView.addArrangedSubview(storyThumbnailImageView)
        
        let innerStackView = UIStackView()
        innerStackView.alignment = .fill
        innerStackView.distribution = .fill
        innerStackView.axis = .vertical
        innerStackView.spacing = 8
        
        innerStackView.addArrangedSubview(storyTitleLabel)
        innerStackView.addArrangedSubview(storyAuthorLabel)
        
        stackView.addArrangedSubview(innerStackView)
        
        // adding constrainst for image
        storyThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint
            .activate([
                storyThumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
                storyThumbnailImageView.widthAnchor.constraint(equalToConstant: 100)
            ])

        // adding constraints for stack
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint
            .activate([
                stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
                stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
                stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
                stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
            ])
        
    }
    
    func populate(with viewModel: StoryItemViewModel) {
        self.storyAuthorLabel.text = viewModel.author
        self.storyTitleLabel.text = viewModel.title
        if let imgData = viewModel.imgData, let img = UIImage(data: imgData) {
            self.storyThumbnailImageView.image = img
        }
    }

}
