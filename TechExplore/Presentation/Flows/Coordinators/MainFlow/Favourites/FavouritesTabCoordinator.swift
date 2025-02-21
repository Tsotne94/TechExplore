//
//  FavouritesTabCoordinator.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Foundation
import UIKit
import SwiftUI

protocol FavouritesTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToProductsDetails(productId: Int)
    func goBack()
}

final class DefaultFavouritesTabCoordinator: NSObject, FavouritesTabCoordinator {
    var rootViewController: UINavigationController
    
    override init() {
        self.rootViewController = UINavigationController()
        rootViewController.isNavigationBarHidden = true
    }
    
    func start() {
        let hostingView = UIHostingController(rootView: FavouritesView())
        rootViewController.setViewControllers([hostingView], animated: false)
    }
    
    func goToProductsDetails(productId: Int) {
//        let viewController = ProductDetailsViewController(id: productId) { [weak self] in
//            self?.goBack()
//        }
//        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func goBack() {
        rootViewController.popViewController(animated: true)
    }
}

extension DefaultFavouritesTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
    }
}
