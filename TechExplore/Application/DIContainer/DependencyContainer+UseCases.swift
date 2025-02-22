//
//  DependencyContainer+UseCases.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

public extension DependencyContainer {
    func registerUseCases() {
        DependencyContainer.root.register {
            Module { DefaultLoadAppStateUseCase() as LoadAppStateUseCase }
            Module { DefaultUpdateAppStateUseCase() as UpdateAppStateUseCase }
            Module { DefaultSignInUseCase() as SignInUseCase }
            Module { DefaultSignUpUseCase() as SignUpUseCase }
            Module { DefaultSignOutUseCase() as SignOutUseCase }
            Module { DefaultKeyChainDeleteDataUseCase() as KeyChainDeleteDataUseCase }
            Module { DefaultKeyChainRetriveDataUseCase() as KeyChainRetriveDataUseCase }
            Module { DefaultKeyChainSaveDataUseCase() as KeyChainSaveDataUseCase }
            Module { DefaultKeyChainUpdateDataUseCase() as KeyChainUpdateDataUseCase }
            Module { DefaultGetCurrentUserUseCase() as GetCurrentUserUseCase }
            Module { DefaultFetchSpecificStatementUseCase() as FetchSpecificStatementUseCase }
            Module { DefaultFetchStatementsUseCase() as FetchStatementsUseCase }
        }
    }
}
