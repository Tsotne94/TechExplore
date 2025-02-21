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
            if let savedStateRaw = UserDefaults.standard.string(forKey: "appState"),
               let savedState = AppState(rawValue: savedStateRaw) {
                promise(.success(savedState))
                return
            }
            
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
