//
//  FetchStatementsUseCase.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Combine

public protocol FetchStatementsUseCase {
    func execute(category: Category?, query: String?) -> AnyPublisher<[Statement], Error>
}

public struct DefaultFetchStatementsUseCase: FetchStatementsUseCase {
    @Inject private var statementRepository: StatementsRepository
    
    public init() { }
    
    public func execute(category: Category?, query: String?) -> AnyPublisher<[Statement], any Error> {
        statementRepository.getStatements(category: category, query: query)
    }
}
