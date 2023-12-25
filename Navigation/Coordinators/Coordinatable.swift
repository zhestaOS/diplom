//
//  Coordinatable.swift
//  Navigation
//
//  Created by Евгения Шевякова on 12.06.2023.
//

import UIKit

protocol Coordinatable: AnyObject {
    var childCoordinators: [Coordinatable] { get }
    func start() -> UIViewController
    func addChildCoordinator(_ coordinator: Coordinatable)
    func removeChildCoordinator(_ coordinator: Coordinatable)
}

protocol ModuleCoordinatable: Coordinatable {
    var navigationController: UINavigationController? { get }
    var module: Module? { get } // ???
    var moduleType: Module.ModuleType { get }
}

extension Coordinatable {
    func addChildCoordinator (_ coordinator: Coordinatable) {}
    func removeChildCoordinator (_ coordinator: Coordinatable) {}
}

