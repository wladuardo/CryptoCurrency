//
//  CustomTabBar.swift
//  CryptoCurrency
//
//  Created by Владислав Ковальский on 09.06.2022.
//

import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {
    
    private lazy var blurEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.tabBar.bounds
        return blurView
    }()
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.setBackgroundImage(UIImage.add, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        return addButton
    }()
    
    override func viewDidLoad() {
        self.delegate = self
        setupBlurEffect()
        setupAddButton()
    }
    
    private func setupBlurEffect() {
        tabBar.addSubview(blurEffect)
        blurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 70),
            addButton.widthAnchor.constraint(equalToConstant: 70),
            addButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -40)
        ])
    }
    
    @objc private func addButtonAction() {
        present(CryptosListTableViewController(), animated: true)
    }
    
}
