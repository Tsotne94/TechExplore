//
//  APIEndpoints.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import MyNetworkManager
import Foundation

public final class RequestMaker {
    static let shared = RequestMaker()
    private init() {}
    
    func request<T: Codable & Sendable, U: Codable>(
        urlString: String,
        modelType: T.Type,
        networkManager: NetworkManager,
        bearer: String? = nil,
        body: U? = nil,
        methodType: HTTPMethodType = .get,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        networkManager.makeRequest(
            urlString: urlString,
            method: methodType,
            modelType: modelType.self,
            requestBody: body,
            bearerToken: bearer
        ) { result in
            completion(result)
        }
    }
}
