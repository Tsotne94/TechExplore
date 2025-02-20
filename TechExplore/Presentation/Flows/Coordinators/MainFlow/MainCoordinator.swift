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
//        homeCoordinator.start()
//        self.childCoordinators.append(homeCoordinator)
//        homeCoordinator.rootViewController.tabBarItem = UITabBarItem(
//            title: "Home",
//            image: UIImage(named: TabBar.home),
//            selectedImage: UIImage(named: TabBar.homeSelected)
//        )
//        
//        shopCoordinator.start()
//        self.childCoordinators.append(shopCoordinator)
//        shopCoordinator.rootViewController.tabBarItem = UITabBarItem(
//            title: "Shop",
//            image: UIImage(named: TabBar.cart),
//            selectedImage: UIImage(named: TabBar.cartSelected)
//        )
//        
//        bagCoordinator.start()
//        self.childCoordinators.append(bagCoordinator)
//        bagCoordinator.rootViewController.tabBarItem = UITabBarItem(
//            title: "Bag",
//            image: UIImage(named: TabBar.bag),
//            selectedImage: UIImage(named: TabBar.bagSelected)
//        )
//        
//        favouriteseCoordinator.start()
//        self.childCoordinators.append(favouriteseCoordinator)
//        favouriteseCoordinator.rootViewController.tabBarItem = UITabBarItem(
//            title: "Favourites",
//            image: UIImage(named: TabBar.favourites),
//            selectedImage: UIImage(named: TabBar.favouritesSelected)
//        )
//        
//        profileeCoordinator.start()
//        self.childCoordinators.append(profileeCoordinator)
//        profileeCoordinator.rootViewController.tabBarItem = UITabBarItem(
//            title: "Profile",
//            image: UIImage(named: TabBar.profile),
//            selectedImage: UIImage(named: TabBar.profileSelected)
//        )
//        
//        self.rootViewController.viewControllers = [
//            homeCoordinator.rootViewController,
//            shopCoordinator.rootViewController,
//            bagCoordinator.rootViewController,
//            favouriteseCoordinator.rootViewController,
//            profileeCoordinator.rootViewController
//        ]
    }
    
    func goToHomePage() {
        rootViewController.selectedIndex = 0
    }
}
