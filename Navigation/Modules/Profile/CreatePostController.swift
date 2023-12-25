//
//  CreatePostController.swift
//  Navigation
//
//  Created by Евгения Шевякова on 24.12.2023.
//

import UIKit

class CreatePostController: UIViewController {
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    private lazy var postTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.toAutoLayout()
        return textView
    }()
    
    private lazy var saveButton: Button = {
        let button = Button()
        button.setTitle(String(localized: "saveButton"), for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    private let callback: (String) -> Void
    
    init(callback: @escaping (String) -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUi()
    }
    
    private func setupUi() {
        view.addSubviews(
            closeButton,
            postTextView,
            saveButton
        )
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 22),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            postTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            postTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.heightAnchor.constraint(equalToConstant: 47),
            saveButton.widthAnchor.constraint(equalToConstant: 262),
            saveButton.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: 66),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
        ])
    }
    
    @objc
    func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    func saveButtonTapped() {
        guard postTextView.text.count > 0 else { return }
        callback(postTextView.text)
        dismiss(animated: true)
    }
}
