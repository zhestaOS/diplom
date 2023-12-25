//
//  Button.swift
//  Navigation
//
//  Created by Евгения Шевякова on 19.12.2023.
//

import UIKit

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .buttonBackground
        layer.cornerRadius = 10
        titleLabel?.font = .systemFont(ofSize: 16)
    }

}
