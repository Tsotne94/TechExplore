//
//  FetchSpecificStatementUseCase.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Combine

public protocol FetchSpecificStatementUseCase {
    func execute(id: Int) -> AnyPublisher<Statement, Error>
}

public struct DefaultFetchSpecificStatementUseCase: FetchSpecificStatementUseCase {
    @Inject private var statementRepository: StatementsRepository
    
    public init() { }
    
    public func execute(id: Int) -> AnyPublisher<Statement, any Error> {
        statementRepository.getSpecificStatement(id: id)
    }
}
