//
//  AuthRegistrationViewModel.swift
//  Navigation
//
//  Created by Евгения Шевякова on 19.12.2023.
//

import Foundation

enum AuthScreenType {
    case login
    case registration
}

protocol AuthRegistrationViewModelProtocol {
    var screenType: AuthScreenType { get }
    var showError: ((AuthError) -> Void)? { get set }
    func handleNextButtonTapped(email: String, password: String)
}

final class AuthRegistrationViewModel: AuthRegistrationViewModelProtocol {
    var coordinator: AuthCoordinator?
    var showError: ((AuthError) -> Void)?
    
    let screenType: AuthScreenType
    let authService: AuthService
    
    init(type: AuthScreenType, authService: AuthService = AuthService()) {
        self.screenType = type
        self.authService = authService
    }
    
    func handleNextButtonTapped(email: String, password: String) {
        switch screenType {
        case .login:
            authService.login(email: email, password: password) { [weak self] result in
                switch result {
                case .success( _):
                    self?.coordinator?.openMainApp()
                case .failure(let failure):
                    self?.showError?(failure)
                }
            }
        case .registration:
            authService.register(email: email, password: password) { [weak self] result in
                switch result {
                case .success( _):
                    self?.coordinator?.openMainApp()
                case .failure(let failure):
                    self?.showError?(failure)
                }
            }
        }
    }
}
