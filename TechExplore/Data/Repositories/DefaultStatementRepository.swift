//
//  DefaultStatementRepository.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Foundation
import Combine
import MyNetworkManager

public struct DefaultStatementRepository: StatementsRepository {
    @Inject private var retriveDataFromKeyChain: KeyChainRetriveDataUseCase
    @Inject private var saveInKeyChain: KeyChainSaveDataUseCase
    private let networkManager: NetworkManager = NetworkManager()
    private let requestMaker: RequestMaker = RequestMaker.shared
    
    public init() { }
    
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
    
    private func getTokenAndExecuteRequest<T: Codable & Sendable>(
        urlString: String,
        modelType: T.Type,
        methodType: HTTPMethodType
    ) -> AnyPublisher<T, Error> {
        retriveDataFromKeyChain.execute(key: "bearer")
            .flatMap { bearerData -> AnyPublisher<T, Error> in
                guard let token = String(data: bearerData, encoding: .utf8) else {
                    return Fail(error: KeychainError.unexpectedDataFormat).eraseToAnyPublisher()
                }
                return executeRequestWithRefresh(
                    urlString: urlString,
                    modelType: modelType,
                    bearer: token,
                    methodType: methodType
                )
            }
            .eraseToAnyPublisher()
    }
    
    private func constructStatementsURL(category: Category?, query: String?) -> String {
        var urlComponents = URLComponents(string: APIEndpointsEnum.statement)!
        var queryItems: [URLQueryItem] = []
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: "\(category.id)"))
        }
        if let query = query {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
        
        urlComponents.queryItems = queryItems.isEmpty ? nil : queryItems
        return urlComponents.url!.absoluteString
    }
    
    private func executeRequestWithRefresh<T: Codable & Sendable>(
        urlString: String,
        modelType: T.Type,
        bearer: String,
        methodType: HTTPMethodType
    ) -> AnyPublisher<T, Error> {
        makeInitialRequest(urlString: urlString, modelType: modelType, bearer: bearer, methodType: methodType)
            .catch { error -> AnyPublisher<T, Error> in
                guard let nsError = error as NSError?, nsError.code == 401 else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                return handleTokenRefresh(urlString: urlString, modelType: modelType, methodType: methodType)
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
    
    private func handleTokenRefresh<T: Codable & Sendable>(
        urlString: String,
        modelType: T.Type,
        methodType: HTTPMethodType
    ) -> AnyPublisher<T, Error> {
        refreshToken()
            .flatMap { newToken in
                makeInitialRequest(
                    urlString: urlString,
                    modelType: modelType,
                    bearer: newToken,
                    methodType: methodType
                )
            }
            .eraseToAnyPublisher()
    }
    
    private func refreshToken() -> AnyPublisher<String, Error> {
        retriveDataFromKeyChain.execute(key: "refresh")
            .flatMap { refreshData -> AnyPublisher<String, Error> in
                guard let refreshToken = String(data: refreshData, encoding: .utf8) else {
                    return Fail(error: KeychainError.unexpectedDataFormat).eraseToAnyPublisher()
                }
                
                return performTokenRefresh(with: refreshToken)
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
        
        saveInKeyChain.execute(key: "bearer", data: tokenData)
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
            .cancel()
    }
}
