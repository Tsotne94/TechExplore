//
//  MainTabBarController.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tintColor: UIColor = .customGreen
        tabBar.tintColor = tintColor
        tabBar.unselectedItemTintColor = .gray
        
        let attributes: [NSAttributedString.Key: Any] = [ .foregroundColor: tintColor ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
        
        tabBar.backgroundColor = .custonWhite
    }
}
