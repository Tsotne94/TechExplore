//
//  LoginViewModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Foundation
import Combine

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {
}

protocol LoginViewModelInput {
    func forgotPassword()
    func logIn()
    func showPassword()
    func hidePassword()
    func signUp()
    func loginWithFacebook()
    func loginWithGoogle()
    
    var email: String { get set }
    var password: String { get set }
    var passwordIsHidden: Bool { get set }
    var isLoading: Bool { get set }
    var showError: Bool { get set }
    var errorMessage: String { get set }
}

protocol LoginViewModelOutput {
//    var output: AnyPublisher<LoginViewModelOutputAction, Never> { get }
}

enum LoginViewModelOutputAction {
    case successfullLogin
    case loginError
}

final class DefaultLoginViewModel: LoginViewModel, ObservableObject {
    @Inject private var authenticationCoordinator: AuthenticationCoordinator
    @Inject private var saveInKeyChainUseCase: KeyChainSaveDataUseCase
    @Inject private var signInUseCase: SignInUseCase
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var passwordIsHidden: Bool = true
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    
    private var _output = PassthroughSubject<LoginViewModelOutputAction, Never>()
    var output: AnyPublisher<LoginViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init() { setupBinding() }
    
    func forgotPassword() {
        
    }
    
    private func setupBinding() {
        self._output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
            switch status {
            case .successfullLogin:
                print("successfull lgin")
            case .loginError:
                self?.errorMessage = "loginError.description"
                self?.showError = true
            }
        }.store(in: &subscriptions)
    }
    
    func logIn() {
        isLoading = true
        signInUseCase.execute(email: email.lowercased(), password: password)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?._output.send(.loginError)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] tokens in
                self?.handleLogin(loginresponse: tokens)
            }
            .store(in: &subscriptions)
    }
    private func handleLogin(loginresponse: LoginResponse) {
        guard let bearer = loginresponse.access.data(using: .utf8) else {
            _output.send(.loginError)
            return
        }
        
        guard let refresh = loginresponse.refresh.data(using: .utf8) else {
            _output.send(.loginError)
            return
        }
        
        let saveBearer = saveInKeyChainUseCase.execute(key: "bearer", data: bearer)
        let saveRefresh = saveInKeyChainUseCase.execute(key: "refresh", data: refresh)
        
        Publishers.Zip(saveBearer, saveRefresh)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully saved both tokens")
                case .failure(let error):
                    print("Error saving tokens: \(error.localizedDescription)")
                    self._output.send(.loginError)
                }
            } receiveValue: { _, _ in
                self._output.send(.successfullLogin)
                self.authenticationCoordinator.successfullLogin()
            }
            .store(in: &subscriptions)
    }
    func showPassword() {
        passwordIsHidden = false
    }
    
    func hidePassword() {
        passwordIsHidden = true
    }
    
    func signUp() {
        self.authenticationCoordinator.goToSignUp(animated: true)
    }
    
    func loginWithFacebook() {
        //#warning("implement if you have time!!!")
    }
    
    func loginWithGoogle() {
        //#warning("implement if you have time!!!")
    }
}
