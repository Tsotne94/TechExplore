//
//  ApplyUseCase.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Combine

public protocol ApplyUseCase {
    func execute(id: Int) -> AnyPublisher<Void, Error>
}

public struct DefaultApplyUseCase: ApplyUseCase {
    @Inject private var statementRepository: StatementsRepository
    
    public init() { }
    
    public func execute(id: Int) -> AnyPublisher<Void, any Error> {
        statementRepository.apply(statementId: id)
    }
}
