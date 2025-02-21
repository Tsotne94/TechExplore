//
//  KeyChainUpdateUseCase.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Combine
import Foundation

public protocol KeyChainUpdateDataUseCase {
    func execute(key: String, newData: Data) -> AnyPublisher<Void, Error>
}

public struct DefaultKeyChainUpdateDataUseCase: KeyChainUpdateDataUseCase {
    @Inject private var keyChainRepository: KeyChainRepository
    
    public init() { }
    
    public func execute(key: String, newData: Data) -> AnyPublisher<Void, any Error> {
        keyChainRepository.updateData(key: key, newData: newData)
    }
}
