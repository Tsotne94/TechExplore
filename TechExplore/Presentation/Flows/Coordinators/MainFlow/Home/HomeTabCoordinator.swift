//
//  HomeTabCoordinator.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Foundation
import UIKit

protocol HomeTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToProductsDetails(productId: Int)
    func goBack()
}

final class DefaultHomeTabCoordinator: NSObject, HomeTabCoordinator {
    var rootViewController = UINavigationController()
    
    override init() {
        super.init()
        rootViewController.delegate = self
    }
    
    func start() {
//        let viewController = HomeViewController()
//        rootViewController.setViewControllers([viewController], animated: false)
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

extension DefaultHomeTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
    }
}
