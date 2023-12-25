//
//  FavouritesCoordinator.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import UIKit

final class FavouritesCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []
    
    func start() -> UIViewController {
        let viewModel = FavouritesViewModel()
        viewModel.coordinator = self
        let viewController = FavouritesViewController(viewModel: viewModel)
        let tabBarItem = UITabBarItem(title: String(localized: "favouritesTitle"), image: UIImage.tabBarFavourites, selectedImage: UIImage.tabBarFavourites)
        viewController.tabBarItem = tabBarItem
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
