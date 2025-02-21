//
//  DependencyContainer+Repositories.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

public extension DependencyContainer {
    func registerRepositories() {
        DependencyContainer.root.register {
            Module { DefaultAppStateRepository() as AppStateRepository }
            Module { DefaultAuthenticationRepository() as AuthenticationRepository }
            Module { DefaultKeyChainRepository() as KeyChainRepository }
        }
    }
}
