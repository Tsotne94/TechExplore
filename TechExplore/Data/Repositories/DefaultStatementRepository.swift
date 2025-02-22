//
//  DefaultStatementRepository.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Foundation
import Combine
import MyNetworkManager

// MARK: - Statement Repository Implementation
public struct DefaultStatementRepository: StatementsRepository {
    // MARK: - Dependencies
    @Inject private var retrieveDataFromKeyChain: KeyChainRetriveDataUseCase
    @Inject private var saveInKeyChain: KeyChainSaveDataUseCase
    private let networkManager = NetworkManager()
    private let requestMaker = RequestMaker.shared
    
    // MARK: - Constants
    private enum Constants {
        static let bearerKey = "bearer"
        static let refreshKey = "refresh"
        static let maxRetryCount = 1
    }
    
    public init() { }
    
    // MARK: - Public Methods
    public func getStatements(category: Category?, query: String?) -> AnyPublisher<[Statement], Error> {
        getTokenAndExecuteRequest(
            urlString: constructStatementsURL(category: category, query: query),
            modelType: [Statement].self,
            methodType: .get
        )
    }
    
    public func getSpecificStatement(id: Int) -> AnyPublisher<Statement, Error> {
        getTokenAndExecuteRequest(
            urlString: "\(APIEndpointsEnum.specificPost)\(id)",
            modelType: Statement.self,
            methodType: .get
        )
    }
    
    public func getCategories() -> AnyPublisher<[Category], Error> {
        getTokenAndExecuteRequest(
            urlString: APIEndpointsEnum.categories,
            modelType: [Category].self,
            methodType: .get
        )
    }
    
    // MARK: - Private Methods
    private func constructStatementsURL(category: Category?, query: String?) -> String {
        var urlComponents = URLComponents(string: APIEndpointsEnum.statement)!
        var queryItems: [URLQueryItem] = []
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "categories", value: "\(category.id)"))
        }
        if let query = query, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: query))
        }
        
        urlComponents.queryItems = queryItems.isEmpty ? nil : queryItems
        return urlComponents.url?.absoluteString ?? APIEndpointsEnum.statement
    }
    
    private func getTokenAndExecuteRequest<T: Codable & Sendable>(
        urlString: String,
        modelType: T.Type,
        methodType: HTTPMethodType
    ) -> AnyPublisher<T, Error> {
        retrieveDataFromKeyChain.execute(key: Constants.bearerKey)
            .tryMap { bearerData -> String in
                guard let token = String(data: bearerData, encoding: .utf8) else {
                    throw KeychainError.unexpectedDataFormat
                }
                return token
            }
            .flatMap { token in
                executeRequestWithRefresh(
                    urlString: urlString,
                    modelType: modelType,
                    bearer: token,
                    methodType: methodType
                )
            }
            .eraseToAnyPublisher()
    }
    
    private func executeRequestWithRefresh<T: Codable & Sendable>(
        urlString: String,
        modelType: T.Type,
        bearer: String,
        methodType: HTTPMethodType,
        retryCount: Int = 0
    ) -> AnyPublisher<T, Error> {
        makeInitialRequest(urlString: urlString, modelType: modelType, bearer: bearer, methodType: methodType)
            .tryCatch { error -> AnyPublisher<T, Error> in
                guard let nsError = error as NSError?,
                      nsError.code == 401,
                      retryCount < Constants.maxRetryCount else {
                    throw error
                }
                
                return refreshToken()
                    .flatMap { newToken in
                        executeRequestWithRefresh(
                            urlString: urlString,
                            modelType: modelType,
                            bearer: newToken,
                            methodType: methodType,
                            retryCount: retryCount + 1
                        )
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func makeInitialRequest<T: Codable & Sendable>(
        urlString: String,
        modelType: T.Type,
        bearer: String,
        methodType: HTTPMethodType
    ) -> AnyPublisher<T, Error> {
        Future { promise in
            self.requestMaker.request(
                urlString: urlString,
                modelType: modelType,
                networkManager: self.networkManager,
                bearer: bearer,
                body: nil as EmptyBody?,
                methodType: methodType
            ) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }
    
    private func refreshToken() -> AnyPublisher<String, Error> {
        retrieveDataFromKeyChain.execute(key: Constants.refreshKey)
            .tryMap { refreshData -> String in
                guard let refreshToken = String(data: refreshData, encoding: .utf8) else {
                    throw KeychainError.unexpectedDataFormat
                }
                return refreshToken
            }
            .flatMap { refreshToken in
                performTokenRefresh(with: refreshToken)
            }
            .eraseToAnyPublisher()
    }
    
    private func performTokenRefresh(with refreshToken: String) -> AnyPublisher<String, Error> {
        Future { promise in
            let refreshRequest = RefreshRequest(refresh: refreshToken)
            self.requestMaker.request(
                urlString: APIEndpointsEnum.refresh,
                modelType: RefreshResponse.self,
                networkManager: self.networkManager,
                bearer: nil,
                body: refreshRequest,
                methodType: .post
            ) { result in
                switch result {
                case .success(let response):
                    self.saveNewToken(response.access, promise: promise)
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    private func saveNewToken(_ token: String, promise: @escaping (Result<String, Error>) -> Void) {
        guard let tokenData = token.data(using: .utf8) else {
            promise(.failure(KeychainError.unexpectedDataFormat))
            return
        }
        
        let _: AnyCancellable = saveInKeyChain.execute(key: Constants.bearerKey, data: tokenData)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                },
                receiveValue: { _ in
                    promise(.success(token))
                }
            )
    }
}
