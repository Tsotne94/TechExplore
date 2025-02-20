//
//  SignUpUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine

public protocol SignUpUseCase {
    func execute(email: String, password: String) -> AnyPublisher<User, Error>
}

public struct DefaultSignUpUseCase: SignUpUseCase {
    @Inject private var authenticationRepository: AuthenticationRepository
    
    public init() { }
    
    public func execute(email: String, password: String) -> AnyPublisher<User, Error> {
        authenticationRepository.signUp(email: email, password: password)
    }
}
