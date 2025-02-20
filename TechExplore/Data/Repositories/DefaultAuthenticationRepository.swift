//
//  DefaultAuthenticationRepository.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Foundation
import Combine

public struct DefaultAuthenticationRepository: AuthenticationRepository {
    
    public init() { }
    
    public func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            promise(.success(User()))
        }
        .eraseToAnyPublisher()
    }
    
    public func signUp(email: String, password: String) -> AnyPublisher<User, Error> {
        Future<User, Error> { promise in
            promise(.success(User()))
        }
        .eraseToAnyPublisher()
    }
    
    public func signOut() -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}
