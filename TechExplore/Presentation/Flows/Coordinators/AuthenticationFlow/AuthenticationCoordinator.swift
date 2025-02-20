//
//  AuthenticationCoordinator.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Foundation
import UIKit
import SwiftUI

protocol AuthenticationCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToSignUp(animated: Bool)
    func goBack(animated: Bool)
    func popToRoot(animated: Bool)
    func successfullLogin()
}

final class DefaultAuthenticationCoordinator: NSObject, AuthenticationCoordinator {
    var rootViewController = UINavigationController()
    
    @Inject private var parentCoordinator: AppFlowCoordinator

    override init() {
        super.init()
        rootViewController.delegate = self
    }
    
    func start() {
//        let hostingView = UIHostingController(rootView: LoginView())
//        rootViewController.setViewControllers([hostingView], animated: false)
    }
    
    func goToSignUp(animated: Bool) {

    }
    
    func goBack(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
    
    func successfullLogin() {
        parentCoordinator.viewModel.startMainFlow()
    }
    
    func popToRoot(animated: Bool) {
        rootViewController.popToRootViewController(animated: animated)
    }
}

extension DefaultAuthenticationCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
    }
}
