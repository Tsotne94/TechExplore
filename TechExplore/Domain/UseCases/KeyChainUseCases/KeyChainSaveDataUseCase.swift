//
//  KeyChainSaveUseCase.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Combine
import Foundation

public protocol KeyChainSaveDataUseCase {
    func execute(key: String, data: Data) -> AnyPublisher<Void, Error>
}

public struct DefaultKeyChainSaveDataUseCase: KeyChainSaveDataUseCase {
    @Inject private var keyChainRepository: KeyChainRepository
    
    public init() { }
    
    public func execute(key: String, data: Data) -> AnyPublisher<Void, any Error> {
        keyChainRepository.saveData(key: key, data: data)
    }
}
