//
//  UIWindow+Extensions.swift
//  Navigation
//
//  Created by Евгения Шевякова on 20.12.2023.
//

import UIKit

extension UIWindow {
    func replaceRootViewController(_ rootViewController: UIViewController) {
        
        // if rootViewController isn't set yet. Just set it instead of animating the change
        if self.rootViewController == nil {
            self.rootViewController = rootViewController
            self.makeKeyAndVisible()
            return
        }
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        
        layer.add(transition, forKey: kCATransition)
        
        if let vc = self.rootViewController {
            vc.dismiss(animated: false, completion: nil)
        }
        self.rootViewController = rootViewController
    }
}
