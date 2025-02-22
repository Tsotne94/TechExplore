//
//  DefaultAppStateRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine
import Foundation

public final class DefaultAppStateRepository: AppStateRepository {
    @Inject private var keychainGetDataUseCase: KeyChainRetriveDataUseCase
    @Inject private var keychainSaveDataUseCase: KeyChainSaveDataUseCase
    
    public init() { }
    
    public func loadAppState() -> AnyPublisher<AppState, Never> {
        return keychainGetDataUseCase.execute(key: "appState")
            .map { data -> AppState in
                if let stateString = String(data: data, encoding: .utf8),
                   let state = AppState(rawValue: stateString) {
                    return state
                }
                return .authentication
            }
            .replaceError(with: .authentication)
            .eraseToAnyPublisher()
    }
    
    
    private var cancellables = Set<AnyCancellable>()
    
    public func saveAppState(_ state: AppState) {
        guard let data = state.rawValue.data(using: .utf8) else {
            print("Failed to convert appState to Data")
            return
        }
        
        let _: AnyCancellable = keychainSaveDataUseCase.execute(key: "appState", data: data)
            .sink { completion in
                switch completion {
                case .finished:
                    print("saved")
                case .failure(let error):
                    print("failed to save app state: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                print("saved")
            }
    }
}
