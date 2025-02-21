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
    
    @Published var statements: [Statement] = []
    @Published var selectedCategory = Category(id: 1, title: "cool", description: "cooler")
    @Published var searchText = ""
    @Published var activeTag: Tag = .first
    @Published var isSearching: Bool = false
    @Published var messages: [Message] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        fetchStatements()
        setupDummyMessages()
    }
    
    func fetchStatements() {
        statements = [
        ]
    }
    
    func filteredFetch() {
        let filteredMessages = messages.filter { message in
            if searchText.isEmpty { return true }
            return message.title.localizedCaseInsensitiveContains(searchText)
        }
        messages = filteredMessages
    }
    
    func goToDetails(message: Message) {
        homeTabCoordinator.goToProductsDetails(productId: 1)
    }
    
    func updateActiveTag(_ tag: Tag) {
        activeTag = tag
        filteredFetch()
    }
    
    func toggleSearch(_ isActive: Bool) {
        isSearching = isActive
        if !isActive {
            searchText = ""
        }
    }
    
    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filteredFetch()
            }
            .store(in: &cancellables)
    }
    
    private func setupDummyMessages() {
        messages = (0...20).map { index in
            Message(
                id: UUID(),
                title: "Message \(index)",
                content: "Content for message \(index)",
                timestamp: Date()
            )
        }
    }
}

struct Message: Identifiable {
    let id: UUID
    let title: String
    let content: String
    let timestamp: Date
}
