//
//  KeyChainRetriveUseCase.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Combine
import Foundation

public protocol KeyChainRetriveDataUseCase {
    func execute(key: String) -> AnyPublisher<Data, Error>
}

public struct DefaultKeyChainRetriveDataUseCase: KeyChainRetriveDataUseCase {
    @Inject private var keyChainRepository: KeyChainRepository
    
    public init() { }
    
    public func execute(key: String) -> AnyPublisher<Data, any Error> {
        keyChainRepository.getData(key: key)
    }
}
