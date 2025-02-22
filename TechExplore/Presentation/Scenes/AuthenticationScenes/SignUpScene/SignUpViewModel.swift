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

import Foundation
import Combine

final class DefaultSignUpViewModel: SignUpViewModel, ObservableObject {
    @Inject private var authenticationCoordinator: AuthenticationCoordinator
    @Inject private var signUpUseCase: SignUpUseCase
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
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
    
    private func extractNames(from fullName: String) -> (firstName: String, lastName: String) {
        let components = fullName.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        if components.count > 1 {
            let firstName = components[0]
            let lastName = components.dropFirst().joined(separator: " ")
            return (firstName, lastName)
        }
        return (fullName, "") 
    }
    
    func signUp() {
        isLoading = true
        
        guard validateInputs() else {
            isLoading = false
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: dateOfBirth)
        
        let (firstName, lastName) = extractNames(from: name)
        
        let user = SignUpRequest(
            email: email,
            password: password,
            confirmPassword: confirmPasswod,
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateString,
            phoneNumber: phoneNumber
        )
        
        signUpUseCase.execute(signupRequest: user)
            .flatMap { [weak self] user -> AnyPublisher<Void, Error> in
                guard self != nil else {
                    return Fail(error: NSError(domain: "SignUpError", code: -1, userInfo: nil))
                        .eraseToAnyPublisher()
                }
                
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    self?._output.send(.successfullSignUp)
                    self?.authenticationCoordinator.goBack(animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?._output.send(.signUpError)
                }
            } receiveValue: { _ in
                print("User registration and data save completed successfully")
            }
            .store(in: &subscriptions)
    }
    
    func validateInputs() -> Bool {
        guard !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPasswod.isEmpty,
              !phoneNumber.isEmpty else {
            _output.send(.signUpError)
            return false
        }
        
        // Validate that name contains at least two parts
        let nameComponents = name.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        guard nameComponents.count >= 2 else {
            alertTitle = "Invalid Name"
            alertMessage = "Please enter both first name and last name separated by space"
            showAlert = true
            _output.send(.signUpError)
            return false
        }
        
        guard password == confirmPasswod else {
            _output.send(.signUpError)
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            _output.send(.signUpError)
            return false
        }
        
        let phoneRegex = "^[0-9+]{9,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        guard phonePredicate.evaluate(with: phoneNumber) else {
            _output.send(.signUpError)
            return false
        }
        
        return true
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
}
