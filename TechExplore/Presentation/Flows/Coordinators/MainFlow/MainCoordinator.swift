//
//  MainCoordinator.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import UIKit
import SwiftUI

protocol MainCoordinator: Coordinator {
    func goToHomePage()
    var rootViewController: UITabBarController { get }
    var childCoordinators: [Coordinator] { get }
}

final class DefaultMainCoordinator: MainCoordinator {
    @Inject private var parentCoordinator: AppFlowCoordinator
    
    @Inject private var homeCoordinator: HomeTabCoordinator
    @Inject private var favouriteseCoordinator: FavouritesTabCoordinator
    @Inject private var profileeCoordinator: ProfileTabCoordinator
    
    var rootViewController: UITabBarController
    var childCoordinators = [Coordinator]()
    
    init() {
        self.rootViewController = MainTabBarController()
    }
    
    func start() {        
        homeCoordinator.start()
        self.childCoordinators.append(homeCoordinator)
        homeCoordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "homeHighlighted")
        )
        
        favouriteseCoordinator.start()
        self.childCoordinators.append(favouriteseCoordinator)
        favouriteseCoordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "Favourites",
            image: UIImage(named: "heart"),
            selectedImage: UIImage(named: "heartHighlighted")
        )
        
        profileeCoordinator.start()
        self.childCoordinators.append(profileeCoordinator)
        profileeCoordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "profile"),
            selectedImage: UIImage(named: "profileHighlighted")
        )
        
        self.rootViewController.viewControllers = [
            homeCoordinator.rootViewController,
            favouriteseCoordinator.rootViewController,
            profileeCoordinator.rootViewController
        ]
    }
    
    func goToHomePage() {
        rootViewController.selectedIndex = 0
    }
}
