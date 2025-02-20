//
//  UpdateAppStateUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

public protocol UpdateAppStateUseCase {
    func execute(state: AppState)
}

public struct DefaultUpdateAppStateUseCase: UpdateAppStateUseCase {
    @Inject private var appStateRepository: AppStateRepository
    
    public init() { }
    
    public func execute(state: AppState) {
        appStateRepository.saveAppState(state)
    }
}
