//
//  DefaultKeyChainRepository.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Combine
import Foundation

public struct DefaultKeyChainRepository: KeyChainRepository {
    
    public init() { }
    
    public func updateData(key: String, newData: Data) -> AnyPublisher<Void, any Error> {
        Future { promise in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]
            
            let attributes: [String: Any] = [
                kSecValueData as String: newData
            ]
            
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            
            switch status {
            case errSecSuccess:
                promise(.success(()))
            case errSecItemNotFound:
                self.saveData(key: key, data: newData)
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                promise(.failure(error))
                            }
                        },
                        receiveValue: { promise(.success(())) }
                    )
                    .cancel()
            default:
                promise(.failure(KeychainError.unhandledError(status: status)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func saveData(key: String, data: Data) -> AnyPublisher<Void, any Error> {
        Future { promise in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            switch status {
            case errSecSuccess:
                promise(.success(()))
            case errSecDuplicateItem:
                self.updateData(key: key, newData: data)
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                promise(.failure(error))
                            }
                        },
                        receiveValue: { promise(.success(())) }
                    )
                    .cancel()
            default:
                promise(.failure(KeychainError.unhandledError(status: status)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func getData(key: String) -> AnyPublisher<Data, any Error> {
        Future { promise in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true
            ]
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            
            switch status {
            case errSecSuccess:
                if let data = result as? Data {
                    promise(.success(data))
                } else {
                    promise(.failure(KeychainError.unexpectedDataFormat))
                }
            case errSecItemNotFound:
                promise(.failure(KeychainError.itemNotFound))
            default:
                promise(.failure(KeychainError.unhandledError(status: status)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteData(key: String) -> AnyPublisher<Void, any Error> {
        Future { promise in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]
            
            let status = SecItemDelete(query as CFDictionary)
            
            switch status {
            case errSecSuccess:
                promise(.success(()))
            case errSecItemNotFound:
                promise(.failure(KeychainError.itemNotFound))
            default:
                promise(.failure(KeychainError.unhandledError(status: status)))
            }
        }
        .eraseToAnyPublisher()
    }
}
