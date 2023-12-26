//
//  AuthRegistrationViewController.swift
//  Navigation
//
//  Created by Евгения Шевякова on 19.12.2023.
//

import UIKit

class AuthRegistrationViewController: UIViewController {
    
    var viewModel: AuthRegistrationViewModelProtocol
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.toAutoLayout()
        return scrollView
    }()
    
    private var frameGuide = UILayoutGuide()
    private var contentGuide = UILayoutGuide()
    
    private let contentView: UIView = {
      let contentView = UIView()
      contentView.toAutoLayout()
      return contentView
    }()
    
    private lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.toAutoLayout()
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = String(localized: "emailPlaceholder")
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.titleHead.cgColor
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 14, height: 0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        textField.delegate = self
        textField.tag = 0
        textField.toAutoLayout()
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = String(localized: "passwordPlaceholder")
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.titleHead.cgColor
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 14, height: 0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.returnKeyType = .done
        textField.delegate = self
        textField.tag = 1
        textField.toAutoLayout()
        return textField
    }()
    
    private lazy var nextButton: Button = {
        let button = Button()
        button.setTitle(String(localized: "nextButton").uppercased(), for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "termsLabel")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .placeholderTextField
        label.toAutoLayout()
        return label
    }()
    
    init(viewModel: AuthRegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        frameGuide = scrollView.frameLayoutGuide
        contentGuide = scrollView.contentLayoutGuide
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthRegistrationViewController.backgroundTap))
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
        
        view.backgroundColor = .systemBackground
        setupBackButton()
        setupViews()
        updateState()
        bindCallback()
    }
    
    private func bindCallback() {
        viewModel.showError = { [weak self] authError in
            guard let self else {
                return
            }
            switch authError {
            case .incorrectEmail:
                Alert.shared.showError(with: "alert_incorrect_email", vc: self)
            case .incorrectPassword:
                Alert.shared.showError(with: "alert_incorrect_password", vc: self)
            case .fbRegEmailAlreadyInUse(let desc), .fbRegInvalidEmail(let desc), .fbRegWeakPassword(let desc), .fbRegUnexpected(let desc),
                    .fbAuthInvalidCredential(let desc), .fbAuthInvalidEmail(let desc), .fbAuthWrongPassword(let desc), .fbAuthUnexpected(let desc):
                Alert.shared.showError(with: desc, vc: self)
            case .emptyFields:
                Alert.shared.showError(with: "alert_incorrect_clear", vc: self)
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            registrationLabel,
            emailTextField,
            passwordTextField,
            nextButton,
            termsLabel
        )
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor),
            
            registrationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            registrationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            emailTextField.widthAnchor.constraint(equalToConstant: 260),
            emailTextField.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 50),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.widthAnchor.constraint(equalToConstant: 260),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.heightAnchor.constraint(equalToConstant: 47),
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 60),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            termsLabel.widthAnchor.constraint(equalToConstant: 258),
            termsLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 16),
            termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    func updateState() {
        var titleString: String
        var titleColor: UIColor
        switch viewModel.screenType {
        case .login:
            titleString = String(localized: "loginTitle")
            titleColor = .titleAccentHead
        case .registration:
            titleString = String(localized: "registrationTitle")
            titleColor = .titleHead
        }
        registrationLabel.text = titleString.uppercased()
        
        registrationLabel.textColor = titleColor
    }
    
    private func setupBackButton() {
        let image = UIImage(named: "backArrow")?.withRenderingMode(.alwaysTemplate)
        
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .buttonBackground
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.handleNextButtonTapped(email: email, password: password)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc
    private func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension AuthRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}
