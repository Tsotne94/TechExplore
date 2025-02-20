//
//  AppStateRepository.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

import Combine

public protocol AppStateRepository {
    func loadAppState() -> AnyPublisher<AppState, Never>
    func saveAppState(_ state: AppState)
    func markHasSeenOnboarding()
}
