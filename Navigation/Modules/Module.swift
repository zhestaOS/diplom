//
//  Module.swift
//  Navigation
//
//  Created by Евгения Шевякова on 28.06.2023.
//

import UIKit

protocol ViewModelProtocol: AnyObject {}

struct Module {
    enum ModuleType {
        case auth, login, registration
        case profile
        case feed
    }
    
    let moduleType: ModuleType
    let viewModel: ViewModelProtocol
    let view: UIViewController
}

extension Module.ModuleType {
    var tabBarItem: UITabBarItem? {
        switch self {
        case .profile:
            return UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        case .feed:
            return UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: 0)
        case .auth, .login, .registration:
            return nil
        }
    }
}
