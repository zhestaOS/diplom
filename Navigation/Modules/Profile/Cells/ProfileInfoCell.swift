//
//  ProfileInfoCell.swift
//  Navigation
//
//  Created by Евгения Шевякова on 22.12.2023.
//

import UIKit

class ProfileInfoCell: UITableViewCell {
    
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
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .text
        label.toAutoLayout()
        return label
    }()
    
    private lazy var createPostButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .accent
        button.setTitleColor(.buttonTitle, for: .normal)
        button.setTitle(String(localized: "sendPost"), for: .normal)
        button.addTarget(self, action: #selector(createPostButtonTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    var createPostCallback: (() -> Void)?
    
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
            createPostButton
        )
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            
            userNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            
            createPostButton.heightAnchor.constraint(equalToConstant: 48),
            createPostButton.widthAnchor.constraint(equalToConstant: 344),
            createPostButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 22),
            createPostButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createPostButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
        ])
    }
    
    func update(email: String) {
        userNameLabel.text = email
    }
    
    func updateAvatar(image: UIImage) {
        avatarImageView.image = image
    }
    
    @objc
    func createPostButtonTapped() {
        createPostCallback?()
    }

}
