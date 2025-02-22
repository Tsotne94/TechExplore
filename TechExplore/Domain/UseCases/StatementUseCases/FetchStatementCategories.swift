//
//  FetchStatementCategories.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Combine

public protocol FetchStatementCategories {
    func execute() -> AnyPublisher<[Category], Error>
}

public struct DefaultFetchStatementCategories: FetchStatementCategories {
    @Inject private var statementsRepository: StatementsRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<[Category], any Error> {
        statementsRepository.getCategories()
    }
}
