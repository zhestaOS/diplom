//
//  AuthMainViewController.swift
//  Navigation
//
//  Created by Евгения Шевякова on 17.12.2023.
//

import UIKit

class AuthMainViewController: UIViewController {
    let viewModel: AuthMainViewModelProtocol
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "authLogo")
        imageView.toAutoLayout()
        return imageView
    }()
    
    private lazy var registrationButton: Button = {
        let button = Button()
        button.setTitle(String(localized: "registrationButton").uppercased(), for: .normal)
        button.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(String(localized: "loginButton"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.buttonClearTitle, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    init(viewModel: AuthMainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(registrationButton)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 344),
            imageView.widthAnchor.constraint(equalToConstant: 344),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 138),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            registrationButton.heightAnchor.constraint(equalToConstant: 47),
            registrationButton.widthAnchor.constraint(equalToConstant: 262),
            registrationButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 66),
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func registrationButtonTapped() {
        viewModel.handleRegistrationButtonTapped()
    }
    
    @objc
    private func loginButtonTapped() {
        viewModel.handleLoginButtonTapped()
    }
    
}
