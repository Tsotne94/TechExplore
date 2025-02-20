//
//  OnboardingCoordinator.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Foundation
import UIKit
import Combine

protocol OnboardingCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}

final class DefaultOnboardingCoordinator: OnboardingCoordinator {
    var rootViewController = UIViewController()
    @Inject private var parentCoordinator: AppFlowCoordinator
    
    init() {

    }
    
    func start() {
        rootViewController = ViewController()
    }
}
