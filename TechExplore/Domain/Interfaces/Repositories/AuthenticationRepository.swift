//
//  AuthenticationRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine

public protocol AuthenticationRepository {
    func signIn(email: String, password: String) -> AnyPublisher<User, Error>
    func signUp(email: String, password: String) -> AnyPublisher<User, Error>
    func signOut() -> AnyPublisher<Void, Never>
}
