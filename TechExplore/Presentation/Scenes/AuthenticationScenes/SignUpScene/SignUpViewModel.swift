//
//  SignUpViewModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//



import Combine
import Foundation

protocol SignUpViewModel: SignUpViewModelInput, SignUpViewModelOutput {
}

protocol SignUpViewModelInput {
    func signUp()
    func showPassword()
    func hidePassword()
    func showConfirmPassword()
    func hideConfirmPassword()
    func goToLogin()
    
    var name: String { get set }
    var email: String { get set }
    var password: String { get set }
    var confirmPasswod: String { get set }
    var passwordIsHidden: Bool { get set }
    var confirmPasswordHidden: Bool { get set }
    var isLoading: Bool { get set }
    var showAlert: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
}

protocol SignUpViewModelOutput {
    var output: AnyPublisher<SignUpViewModelOutputAction, Never> { get }
}

enum SignUpViewModelOutputAction {
    case successfullSignUp
    case signUpError
}

final class DefaultSignUpViewModel: SignUpViewModel, ObservableObject {
    @Inject private var authenticationCoordinator: AuthenticationCoordinator
//    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    @Inject private var signUpUseCase: SignUpUseCase
//    @Inject private var saveUserUseCase: SaveUserUseCase
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordIsHidden: Bool = true
    @Published var isLoading: Bool = false
    @Published var confirmPasswod: String = ""
    @Published var confirmPasswordHidden: Bool = true
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private var _output = PassthroughSubject<SignUpViewModelOutputAction, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    var output: AnyPublisher<SignUpViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    init() {
        setupBinding()
    }
    
    private func setupBinding() {
        _output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .successfullSignUp:
                    self?.alertTitle = "Success!"
                    self?.alertMessage = "Successful Sign Up!"
                    self?.showAlert = true
                case .signUpError:
                    self?.alertTitle = "Error Occurred During Registration!"
                    self?.alertMessage = "error.description"
                    self?.showAlert = true
                }
            }.store(in: &subscriptions)
    }
    
    func signUp() {
        isLoading = true
        
        guard validateInputs() else {
            isLoading = false
            return
        }
        
        signUpUseCase.execute(email: email, password: password)
            .flatMap { [weak self] user -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "SignUpError", code: -1, userInfo: nil))
                        .eraseToAnyPublisher()
                }
                
                let userWithName = User(
                    uid: user.uid,
                    email: self.email,
                    displayName: self.name
                )
                
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    self?._output.send(.successfullSignUp)
                    self?.authenticationCoordinator.successfullLogin()
                case .failure(let error):
//                    let mappedError: SignUpError = ErrorMapper.map(error)
                    self?._output.send(.signUpError)
                }
            } receiveValue: { _ in
                print("User registration and data save completed successfully")
            }
            .store(in: &subscriptions)
    }
    
    func showPassword() {
        passwordIsHidden = false
    }
    
    func hidePassword() {
        passwordIsHidden = true
    }
    
    func showConfirmPassword() {
        confirmPasswordHidden = false
    }
    
    func hideConfirmPassword() {
        confirmPasswordHidden = true
    }
    
    func goToLogin() {
        authenticationCoordinator.goBack(animated: true)
    }
    
    func validateInputs() -> Bool {
        guard !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPasswod.isEmpty else {
//            _output.send(.signUpError(.unknownError("All fields are required")))
            return false
        }
        
        guard password == confirmPasswod else {
//            _output.send(.signUpError(.unknownError("Passwords do not match")))
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
//            _output.send(.signUpError(.invalidEmail))
            return false
        }
        
        return true
    }
}
