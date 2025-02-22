//
//  KeyChainDeletaUseCase.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Combine
import Foundation

public protocol KeyChainDeleteDataUseCase {
    func execute(key: String) -> AnyPublisher<Void, Error>
}

public struct DefaultKeyChainDeleteDataUseCase: KeyChainDeleteDataUseCase {
    @Inject private var keyChainRepository: KeyChainRepository
    
    public init() { }
    
    public func execute(key: String) -> AnyPublisher<Void, any Error> {
        keyChainRepository.deleteData(key: key)
    }
}
