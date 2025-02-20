//
//  AppDelegate.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var appFlowCoordinator: DefaultAppFlowCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DependencyContainer.root.registerUseCases()
        DependencyContainer.root.registerCoordinators()
        DependencyContainer.root.registerRepositories()
        DependencyContainer.root.registerViewModels()
  
        configureWindow()
        
        return true
    }
    
    func configureWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let appFlowCoordinator = DefaultAppFlowCoordinator(window: window)
        
        DependencyContainer.root.register { Module { appFlowCoordinator as AppFlowCoordinator } }
        self.appFlowCoordinator = appFlowCoordinator
        
        appFlowCoordinator.start()
        window.makeKeyAndVisible()
    }
}
