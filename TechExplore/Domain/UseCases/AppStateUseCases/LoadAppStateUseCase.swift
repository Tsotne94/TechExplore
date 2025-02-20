//
//  LoadAppStatusUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Combine

public protocol LoadAppStateUseCase {
    func execute() -> AnyPublisher<AppState, Never>
}

public struct DefaultLoadAppStateUseCase: LoadAppStateUseCase {
    @Inject private var appStateRepository: AppStateRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<AppState, Never> {
        appStateRepository.loadAppState()
    }
}
