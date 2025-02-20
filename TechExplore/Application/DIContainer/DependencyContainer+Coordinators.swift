//
//  DependencyContainer+Coordinators.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

public extension DependencyContainer {
    func registerCoordinators() {
        let authCoordinator = DefaultAuthenticationCoordinator()
        let mainCoordinator = DefaultMainCoordinator()
        
        let homeCoordinator = DefaultHomeTabCoordinator()
        let favouritesCoordinator = DefaultFavouritesTabCoordinator()
        let profileCoordinator = DefaultProfileTabCoordinator()
    
        DependencyContainer.root.register {
            Module { DefaultOnboardingCoordinator() as OnboardingCoordinator }
            Module { authCoordinator as AuthenticationCoordinator }
            Module { mainCoordinator as MainCoordinator }
            Module { homeCoordinator as HomeTabCoordinator }
            Module { favouritesCoordinator as FavouritesTabCoordinator }
            Module { profileCoordinator as ProfileTabCoordinator }
        }
    }
}
