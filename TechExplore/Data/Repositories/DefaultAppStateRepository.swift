//
//  DefaultAppStateRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine
import Foundation

public struct DefaultAppStateRepository: AppStateRepository {
    @Inject private var keychainGetDataUseCase: KeyChainRetriveDataUseCase
    
    public init() { }
    
    public func loadAppState() -> AnyPublisher<AppState, Never> {
        Future<AppState, Never> { promise in
            let _: AnyCancellable = keychainGetDataUseCase.execute(key: "isLoggedIn")
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure:
                        promise(.success(.authentication))
                    }
                } receiveValue: { data in
                    if let stateString = String(data: data, encoding: .utf8),
                       let state = AppState(rawValue: stateString) {
                        promise(.success(state))
                    } else {
                        promise(.success(.authentication))
                    }
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
