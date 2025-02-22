//
//  GetCurrentUserUseCase.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Combine

public protocol GetCurrentUserUseCase {
    func execute() -> AnyPublisher<User, Error>
}

public struct DefaultGetCurrentUserUseCase: GetCurrentUserUseCase {
    @Inject private var authenticationRepository: AuthenticationRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<User, any Error> {
        authenticationRepository.getCurrentUser()
    }
}
