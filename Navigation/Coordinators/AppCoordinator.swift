//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Евгения Шевякова on 19.12.2023.
//

import UIKit

final class AppCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []
    let authService: AuthService
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    func start() -> UIViewController {
        if authService.isLogged() {
            return openMainApp()
        }
        
        let authCoordinator = AuthCoordinator(moduleType: .auth, finishFlow: {
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.replaceRootViewController(self.openMainApp())
        })
        addChildCoordinator(authCoordinator)
        return authCoordinator.start()
    }
    
    func openAuth() {
        
    }
    
    private func openMainApp() -> UIViewController {
        let feedCoordinator = FeedCoordinator()
        let profileCoordinator = ProfileCoordinator {
            let authCoordinator = AuthCoordinator(moduleType: .auth, finishFlow: {
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.replaceRootViewController(self.openMainApp())
            })
            self.childCoordinators.removeAll()
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.replaceRootViewController(authCoordinator.start())
            self.addChildCoordinator(authCoordinator)
        }
        let favouritesCoordinator = FavouritesCoordinator()
        
        let tabBarController = TabBarController(viewControllers: [
            feedCoordinator.start(),
            profileCoordinator.start(),
            favouritesCoordinator.start()
        ])
        
        addChildCoordinator(feedCoordinator)
        addChildCoordinator(profileCoordinator)
        addChildCoordinator(favouritesCoordinator)
        
        return tabBarController
    }
    
}
