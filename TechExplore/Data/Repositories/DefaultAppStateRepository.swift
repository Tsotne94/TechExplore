//
//  DefaultAppStateRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine
import Foundation

public struct DefaultAppStateRepository: AppStateRepository {
    
    public init() { }
    
    public func loadAppState() -> AnyPublisher<AppState, Never> {
        Future<AppState, Never> { promise in
            promise(.success(.mainFlow))
        }
        .eraseToAnyPublisher()
    }
    
    public func saveAppState(_ state: AppState) {
        UserDefaults.standard.set(state.rawValue, forKey: "appState")
    }
    
    public func markHasSeenOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}
