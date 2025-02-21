//
//  KeychainError.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Foundation

enum KeychainError: LocalizedError {
    case itemNotFound
    case unexpectedDataFormat
    case unhandledError(status: OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "The specified item could not be found in the keychain"
        case .unexpectedDataFormat:
            return "The retrieved data is in an unexpected format"
        case .unhandledError(let status):
            return "An unhandled error occurred: \(status)"
        }
    }
}
