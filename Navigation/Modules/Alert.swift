//
//  Alert.swift
//  Navigation
//
//  Created by Евгения Шевякова on 14.08.2023.
//

import Foundation
import UIKit

class Alert: UIAlertController {
    static let shared = Alert()
    
    func showError(with message: String, vc: UIViewController) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        vc.present(alertController, animated: true)
    }
}
