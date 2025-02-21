//
//  DefaultAuthenticationRepository.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Foundation
import Combine
import MyNetworkManager

public struct DefaultAuthenticationRepository: AuthenticationRepository {
    public init() { }
    
    public func signUp(signupRequest: SignUpRequest) -> AnyPublisher<SignUpResponse, any Error> {
        Future { promise in
            RequestMaker.shared.request(
                urlString: APIEndpointsEnum.signUp,
                modelType: SignUpResponse.self,
                networkManager: NetworkManager(),
                bearer: nil,
                body: signupRequest,
                methodType: .post) { result in
                    switch result {
                    case .success(let success):
                        promise(.success(success))
                    case .failure(let failure):
                        promise(.failure(failure))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    public func signIn(loginRequest: LoginRequest) -> AnyPublisher<LoginResponse, any Error> {
        Future { promise in
            RequestMaker.shared.request(
                urlString: APIEndpointsEnum.login,
                modelType: LoginResponse.self,
                networkManager: NetworkManager(),
                bearer: nil,
                body: loginRequest,
                methodType: .post) { result in
                    switch result {
                    case .success(let success):
                        promise(.success(success))
                    case .failure(let failure):
                        promise(.failure(failure))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    public func signOut() -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}

//
//func fetchedAvatars(api: String){
//    Task {
//      do {
//        var token = try keyService.retrieveAccessToken()
//        var headers = ["Authorization": "Bearer \(token)"]
//        
//        do {
//          try await getAvatars(api: api, headers: headers)
//        } catch {
//          if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
//            try await tokenNetwork.getNewToken()
//            token = try keyService.retrieveAccessToken()
//            headers = ["Authorization": "Bearer \(token)"]
//            
//            try await getAvatars(api: api, headers: headers)
//          } else {
//            throw error
//          }
//        }
//      } catch {
//        handleNetworkError(error)
//      }
//    }
//  }
//catch {
//    if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {}
//}
//
//func getNewToken() async throws {
//    let oldToken = try? keyService.retrieveAccessToken()
//    print("⚠️ Old Token: \(oldToken ?? "Unavailable")")
//    
//    guard let refreshToken = try? keyService.retrieveRefreshToken() else {
//      print("❌ Missing Refresh Token")
//      throw NetworkError.noData
//    }
//    
//    let url = EndpointsEnum.token.rawValue
//    let body = RefreshTokenModel(refresh: refreshToken)
//    do {
//      let response: AccessTokenModel = try await webService.postData(
//        urlString: url,
//        headers: nil,
//        body: body
//      )
//      print("🏆 New Token Retrieved: \(response)")
//      try keyService.storeAccessTokens(access: response.access)
//    } catch {
//      print("❌ Failed to Refresh Token: \(error.localizedDescription)")
//      throw error
//    }
//  }
//
//protocol AuthenticatedRequestHandlerProtocol {
//    func sendRequest<T: Decodable>(urlString: String, method: HTTPMethod, headers: [String: String]?, body: Data?, decoder: JSONDecoder) async throws -> T?
//}
//
//final class AuthenticatedRequestHandler: AuthenticatedRequestHandlerProtocol {
//    private let keyChainManager: KeyChainManagerProtocol
//    private let networkService: NetworkServiceProtocol
//    
//    init(keyChainManager: KeyChainManagerProtocol = KeyChainManager(), networkService: NetworkServiceProtocol = NetworkService()) {
//        self.keyChainManager = keyChainManager
//        self.networkService = networkService
//    }
//    
//    func sendRequest<T: Decodable>(urlString: String, method: HTTPMethod, headers: [String: String]? = nil, body: Data? = nil, decoder: JSONDecoder = JSONDecoder()) async throws -> T? {
//            var headers = headers ?? [:]
//            
//            if let token = try? keyChainManager.getAccessToken() {
//                headers["Authorization"] = "Bearer \(token)"
//            } else {
//                throw AuthError.accessTokenMissing
//            }
//            
//            do {
//                let response: T? =  try await networkService.request(urlString: urlString, method: method, headers: headers, body: body, decoder: decoder)
//                return response
//            } catch  {
//                try await refreshAccessToken()
//                
//                if let newAccessToken = try? keyChainManager.getAccessToken() {
//                    headers["Authorization"] = "Bearer \(newAccessToken)"
//                    let response: T? = try await networkService.request(urlString: urlString, method: method, headers: headers, body: body, decoder: decoder)
//                    return response
//                } else {
//                    throw AuthError.accessTokenMissing
//                }
//            }
//            
//        }
//    
//    func refreshAccessToken() async throws {
//            do {
//                guard let refreshToken = try? keyChainManager.getRefreshToken() else {
//                    throw AuthError.refreshTokenMissing
//                }
//                
//                let refreshRequestBody: [String: String] = ["refreshToken": refreshToken]
//                
//                guard let bodyData = try? JSONEncoder().encode(refreshRequestBody) else {
//                    throw AuthError.invalidRequestBody
//                }
//                
//                let response: LoginResponse? = try await networkService.request(
//                    urlString: "https://api.gargar.dev:8088/refresh",
//                    method: .post,
//                    headers: ["Content-Type": "application/json"],
//                    body: bodyData,
//                    decoder: JSONDecoder()
//                )
//                
//                try keyChainManager.storeAccessToken(accessToken: response?.accessToken ?? "")
//            } catch {
//                try keyChainManager.clearTokens()
//                throw AuthError.tokenRefreshFailed
//            }
//        }
//}
