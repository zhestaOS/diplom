//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import UIKit

final class ProfileCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []
    
    let finishFlow: () -> Void
    
    init(finishFlow: @escaping () -> Void) {
        self.finishFlow = finishFlow
    }
    
    func start() -> UIViewController {
        let viewModel = ProfileViewModel()
        viewModel.coordinator = self
        let viewController = ProfileViewController(viewModel: viewModel)
        let tabBarItem = UITabBarItem(title: String(localized: "profileTitle"), image: UIImage.tabBarProfile, selectedImage: UIImage.tabBarProfile)
        viewController.tabBarItem = tabBarItem
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func openCreatePost(from vc: UIViewController, callback: @escaping (String) -> Void) {
        let createPostViewController = CreatePostController(callback: callback)
        vc.present(createPostViewController, animated: true)
    }
    
    func logout() {
        finishFlow()
    }
}
