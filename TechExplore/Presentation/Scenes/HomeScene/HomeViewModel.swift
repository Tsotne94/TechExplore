//
//  HomeViewModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Inject private var homeTabCoordinator: HomeTabCoordinator
    @Inject private var appFlowCoordinator: AppFlowCoordinator
    @Inject private var getStatementsUseCase: FetchStatementsUseCase
    @Inject private var getCategoriesUseCase: FetchStatementCategories
    
    @Published private(set) var statements: [Statement] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    
    @Published var selectedCategory: Category? = nil {
        didSet {
            fetchStatements()
        }
    }
    
    @Published var searchText = ""
    @Published var isSearching: Bool = false {
        didSet {
            if !isSearching {
                searchText = ""
                fetchStatements()
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let debounceInterval: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(300)
    
    init() {
        setupInitialData()
        setupSearchSubscription()
    }
    
    func goToDetails(statement: Statement) {
        homeTabCoordinator.goToProductsDetails(productId: statement.id)
    }
    
    func updateSelectedCategory(_ category: Category?) {
        selectedCategory = category
    }
    
    func toggleSearch(_ isActive: Bool) {
        isSearching = isActive
    }
    
    func refreshData() {
        setupInitialData()
    }
    
    private func setupInitialData() {
        fetchCategories()
        fetchStatements()
    }
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: debounceInterval, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchStatements()
            }
            .store(in: &cancellables)
    }
    
    private func fetchStatements() {
        isLoading = true
        error = nil
        
        getStatementsUseCase.execute(
            category: selectedCategory,
            query: searchText.isEmpty ? nil : searchText
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.handleError(error)
            }
        } receiveValue: { [weak self] statements in
            self?.statements = statements
        }
        .store(in: &cancellables)
    }
    
    private func fetchCategories() {
        getCategoriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: Error) {
        self.error = error
        print("Error: \(error)")
        appFlowCoordinator.viewModel.startAuthentication()
    }
}
