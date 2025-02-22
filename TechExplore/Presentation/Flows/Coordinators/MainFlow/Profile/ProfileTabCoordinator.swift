//
//  ProfileTabCoordinator.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Foundation
import UIKit
import SwiftUI

protocol ProfileTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToSettings()
    func goBack()
}

final class DefaultProfileTabCoordinator: NSObject, ProfileTabCoordinator {
    var rootViewController = UINavigationController()
    
    override init() {
        super.init()
        rootViewController.delegate = self
    }
    
    func start() {
        let viewController = UIHostingController(rootView: ProfileView())
        rootViewController.setViewControllers([viewController], animated: false)
    }
    
    func goToSettings() {
        //to be added
    }
    
    func goBack() {
        rootViewController.popViewController(animated: true)
    }
}

extension DefaultProfileTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
    }
}
