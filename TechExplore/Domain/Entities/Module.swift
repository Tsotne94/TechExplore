//
//  Module.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

public struct Module {
    let name: String
    let resolve: () -> Any
    
    public init<T>(_ name: String? = nil, _ resolve: @escaping () -> T) {
        self.name = name ?? String(describing: T.self)
        self.resolve = resolve
    }
}
