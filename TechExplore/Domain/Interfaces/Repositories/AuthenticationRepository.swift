//
//  AuthenticationRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine

public protocol AuthenticationRepository {
    func signIn(loginRequest: LoginRequest) -> AnyPublisher<LoginResponse, Error>
    func signUp(signupRequest: SignUpRequest) -> AnyPublisher<SignUpResponse, Error>
    func getCurrentUser() -> AnyPublisher<User, Error>
    func signOut() -> AnyPublisher<Void, Never>
}
