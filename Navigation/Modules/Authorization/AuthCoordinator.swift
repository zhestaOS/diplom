//
//  AuthCoordinator.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import UIKit


final class AuthCoordinator: ModuleCoordinatable {
    var moduleType: Module.ModuleType
    var navigationController: UINavigationController?
    let finishFlow: () -> Void
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(moduleType: Module.ModuleType, finishFlow: @escaping () -> Void) {
        self.moduleType = moduleType
        self.finishFlow = finishFlow
    }
    
    func start() -> UIViewController {
        let viewModel = AuthMainViewModel()
        viewModel.coordinator = self
        let viewController = AuthMainViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        return navigationController
    }
    
    func openRegistration() {
        let viewModel = AuthRegistrationViewModel(type: .registration)
        viewModel.coordinator = self
        let viewController = AuthRegistrationViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openLogin() {
        let viewModel = AuthRegistrationViewModel(type: .login)
        viewModel.coordinator = self
        let viewController = AuthRegistrationViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openMainApp() {
        finishFlow()
    }
}
