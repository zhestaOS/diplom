//
//  UIView+Extension.swift
//  Navigation
//
//  Created by Евгения Шевякова on 22.12.2021.
//
import UIKit

public extension UIView {
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    func toAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
