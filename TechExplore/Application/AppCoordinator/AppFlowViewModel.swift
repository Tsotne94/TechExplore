//
//  AppFlowViewModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Foundation
import Combine

public protocol AppFlowViewModel: AppFlowViewModelInput, AppFlowViewModelOutput {}

public protocol AppFlowViewModelInput: AnyObject {
    func startAuthentication()
    func startMainFlow()
    func loadAppState()
    func signOut()
}

public protocol AppFlowViewModelOutput {
    var output: AnyPublisher<AppFlowViewModelOutputAction, Never> { get }
}

public enum AppFlowViewModelOutputAction {
    case startAuthentication
    case startMainFlow
}

public final class DefaultAppFlowViewModel: AppFlowViewModel {
    @Inject var loadAppStateUseCase: LoadAppStateUseCase
    @Inject var updateAppStateUseCase: UpdateAppStateUseCase
    @Inject var signOutUseCase: SignOutUseCase
    
    private let _output = PassthroughSubject<AppFlowViewModelOutputAction, Never>()
    public var output: AnyPublisher<AppFlowViewModelOutputAction, Never> {
        return _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init() {
        loadAppState()
    }
    
    public func startAuthentication() {
        updateAppStateUseCase.execute(state: .authentication)
        _output.send(.startAuthentication)
    }
    
    public func startMainFlow() {
        updateAppStateUseCase.execute(state: .mainFlow)
        _output.send(.startMainFlow)
    }
    
    public func signOut() {
        signOutUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateAppStateUseCase.execute(state: .authentication)
                self?._output.send(.startAuthentication)
            }.store(in: &subscriptions)
    }
    
    public func loadAppState() {
        loadAppStateUseCase.execute()
            .sink(receiveValue: { [weak self] appState in
                switch appState {
                case .authentication:
                    self?.startAuthentication()
                case .mainFlow:
                    self?.startMainFlow()
                }
            })
            .store(in: &subscriptions)
    }
}
