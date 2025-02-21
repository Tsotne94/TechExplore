//
//  SignUpUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine

public protocol SignUpUseCase {
    func execute(signupRequest: SignUpRequest) -> AnyPublisher<SignUpResponse, Error>
}

public struct DefaultSignUpUseCase: SignUpUseCase {
    @Inject private var authenticationRepository: AuthenticationRepository
    
    public init() { }
    
    public func execute(signupRequest: SignUpRequest) -> AnyPublisher<SignUpResponse, Error> {
        authenticationRepository.signUp(signupRequest: signupRequest)
    }
}
