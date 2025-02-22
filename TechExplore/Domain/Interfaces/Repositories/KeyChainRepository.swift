//
//  KeyChainRepository.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Combine
import Foundation

public protocol KeyChainRepository {
    func updateData(key: String, newData: Data) -> AnyPublisher<Void, Error>
    func saveData(key: String, data: Data) -> AnyPublisher<Void, Error>
    func getData(key: String) -> AnyPublisher<Data, Error>
    func deleteData(key: String) -> AnyPublisher<Void, Error>
}
