//
//  PostCell.swift
//  Navigation
//
//  Created by Евгения Шевякова on 23.12.2023.
//

import UIKit

class PostCell: UITableViewCell {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .placeholderAvatar.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .titleHead
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.toAutoLayout()
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .text
        label.toAutoLayout()
        return label
    }()
    
    private lazy var textContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .textContainer
        view.toAutoLayout()
        return view
    }()
    
    private lazy var text: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .text
        label.numberOfLines = 0
        label.toAutoLayout()
        return label
    }()
    
    private lazy var verticalSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .text
        view.toAutoLayout()
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .placeholderText
        view.toAutoLayout()
        return view
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(favsButtonTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    private var post: Post?
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubviews(
            avatarImageView,
            userNameLabel,
            textContainerView
        )
        
        textContainerView.addSubviews(
            text,
            verticalSeparator,
            separatorView,
            favouriteButton
        )
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            userNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            
            textContainerView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            textContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            verticalSeparator.widthAnchor.constraint(equalToConstant: 1),
            verticalSeparator.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: 16),
            verticalSeparator.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: 24),
            verticalSeparator.bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: -4),
            
            text.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: 10),
            text.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: 52),
            text.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -16),

            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 10),
            separatorView.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),
                        
            favouriteButton.heightAnchor.constraint(equalToConstant: 20),
            favouriteButton.widthAnchor.constraint(equalToConstant: 20),
            favouriteButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            favouriteButton.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor, constant: -23),
            favouriteButton.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -18)
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = .placeholderAvatar.withRenderingMode(.alwaysTemplate)
        avatarImageView.tintColor = .titleHead
        userNameLabel.text = nil
        text.text = nil
    }
    
    func update(post: Post) {
        self.post = post
        
        userNameLabel.text = post.email
        text.text = post.text
        
        updateFavButton()
        
        if let avatarUrl = post.avatarUrl {
            StorageServise().download(urlString: avatarUrl) { [weak self] image in
                self?.avatarImageView.image = image
            }
        }
    }
    
    private func updateFavButton() {
        guard let post = post else { return }
        if post.isFav {
            favouriteButton.tintColor = .red
        } else {
            favouriteButton.tintColor = .gray
        }
    }
    
    @objc
    func favsButtonTapped() {
        guard let post = post else { return }
        FirestoreService().updateFavoritesStatus(for: post.postId, isFav: !post.isFav) { [weak self] isSuccess, post in
            guard isSuccess == true else { return }
            self?.post = post
            self?.updateFavButton()
        }
    }
}
