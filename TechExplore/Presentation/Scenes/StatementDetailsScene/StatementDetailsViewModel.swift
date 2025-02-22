//
//  StatementDetailsViewModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Combine
import Foundation

final class StatementDetailsViewModel: ObservableObject {
    @Inject private var appFlowCoordinator: AppFlowCoordinator
    @Inject private var homeTabCoordinator: HomeTabCoordinator
    @Inject private var getSpecificStatementUseCase: FetchSpecificStatementUseCase
    
    @Published var statement: Statement?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let id: Int
    
    init(id: Int) {
        self.id = id
        fetchStatement()
    }
    
    func fetchStatement() {
        isLoading = true
        getSpecificStatementUseCase.execute(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] statement in
                self?.statement = statement
            }
            .store(in: &cancellables)
    }
    
    func goBack() {
        homeTabCoordinator.goBack()
    }
}
