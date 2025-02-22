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
    @Inject private var appflowcoordinator: AppFlowCoordinator
    @Inject private var getStatementsUseCase: FetchStatementsUseCase
    @Inject private var getCategoriesUseCase: FetchStatementCategories
    
    @Published var statements: [Statement] = []
    @Published var filteredStatements: [Statement] = []
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category? = nil
    @Published var searchText = ""
    @Published var isSearching: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        fetchCategories()
        fetchStatements()
    }
    
    func fetchStatements() {
        getStatementsUseCase.execute(category: selectedCategory, query: searchText.isEmpty ? nil : searchText)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching statements: \(error)")
                }
            } receiveValue: { [weak self] statements in
                self?.statements = statements
                self?.filterStatements()
            }
            .store(in: &cancellables)
    }
    
    private func fetchCategories() {
        getCategoriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch categories:", error)
                }
            } receiveValue: { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &cancellables) 
    }
    
    private func filterStatements() {
        filteredStatements = statements.filter { statement in
            if searchText.isEmpty && selectedCategory == nil { return true }
            
            let matchesSearch = searchText.isEmpty ||
            statement.content.localizedCaseInsensitiveContains(searchText) ||
                statement.content.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = selectedCategory == nil ||
            statement.categories.contains(where: { $0 == selectedCategory })
            
            return matchesSearch && matchesCategory
        }
    }
    
    func goToDetails(statement: Statement) {
        homeTabCoordinator.goToProductsDetails(productId: statement.id)
    }
    
    func updateSelectedCategory(_ category: Category?) {
        selectedCategory = category
        fetchStatements()
    }
    
    func toggleSearch(_ isActive: Bool) {
        isSearching = isActive
        if !isActive {
            searchText = ""
            fetchStatements()
        }
    }
    
    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchStatements()
            }
            .store(in: &cancellables)
    }
}
