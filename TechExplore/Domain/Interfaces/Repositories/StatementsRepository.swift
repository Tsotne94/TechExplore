//
//  StatementsRepository.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Combine

public protocol StatementsRepository {
    func getStatements(category: Category?, query: String?) -> AnyPublisher<[Statement], Error>
    func getSpecificStatement(id: Int) -> AnyPublisher<Statement, Error>
    func getCategories() -> AnyPublisher<[Category], Error>
    
}
