//
//  ProfileViewModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    @Inject private var appFlowCoordinator: AppFlowCoordinator
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        isLoading = true
        error = nil
        
        getCurrentUserUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.updateUserData(user)
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        appFlowCoordinator.viewModel.signOut()
    }
    
    private func updateUserData(_ user: User) {
        firstName = user.individual.firstName
        lastName = user.individual.lastName
        email = user.email
    }
}
