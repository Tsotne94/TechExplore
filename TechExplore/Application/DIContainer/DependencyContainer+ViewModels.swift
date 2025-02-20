//
//  DependencyContainer+ViewModels.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

public extension DependencyContainer {
    func registerViewModels() {
        DependencyContainer.root.register {
            Module { DefaultAppFlowViewModel() as AppFlowViewModel }
        }
    }
}
