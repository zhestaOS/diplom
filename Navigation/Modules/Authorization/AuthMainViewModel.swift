//
//  AuthMainViewModel.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import Foundation

protocol AuthMainViewModelProtocol {
    func handleRegistrationButtonTapped()
    func handleLoginButtonTapped()
}

final class AuthMainViewModel: AuthMainViewModelProtocol {
    var coordinator: AuthCoordinator?
    
    func handleRegistrationButtonTapped() {
        coordinator?.openRegistration()
    }
    
    func handleLoginButtonTapped() {
        coordinator?.openLogin()
    }
}
