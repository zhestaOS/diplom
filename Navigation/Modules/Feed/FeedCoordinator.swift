//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import UIKit

final class FeedCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []
    
    func start() -> UIViewController {
        let viewModel = FeedViewModel()
        viewModel.coordinator = self
        let viewController = FeedViewController(viewModel: viewModel)
        let tabBarItem = UITabBarItem(title: String(localized: "feedTitle"), image: UIImage.tabBarFeed, selectedImage: UIImage.tabBarFeed)
        viewController.tabBarItem = tabBarItem
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
