//
//  SignOutUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine

public protocol SignOutUseCase {
    func execute() -> AnyPublisher<Void, Never>
}

public struct DefaultSignOutUseCase: SignOutUseCase {
    @Inject private var authenticationRepository: AuthenticationRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<Void, Never> {
        authenticationRepository.signOut()
    }
}
