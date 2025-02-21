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
        self.clearKeychainIfWillUnistall()
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
    
    func clearKeychainIfWillUnistall() {
        let freshInstall = !UserDefaults.standard.bool(forKey: "alreadyInstalled")
        print("Fresh install: \(freshInstall)")
        
        if freshInstall {            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword
            ]
            
            let status = SecItemDelete(query as CFDictionary)
            
            if status == errSecSuccess {
                print("Keychain cleared successfully")
            } else {
                print("Failed to clear keychain: \(status)")
            }

            UserDefaults.standard.set(true, forKey: "alreadyInstalled")
        } else {
            print("App already installed previously.")
        }
    }
}
