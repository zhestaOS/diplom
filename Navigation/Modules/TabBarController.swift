//
//  TabBar.swift
//  Navigation
//
//  Created by Евгения Шевякова on 19.12.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .titleAccentHead        
    }
}
