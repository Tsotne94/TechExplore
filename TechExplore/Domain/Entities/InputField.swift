//
//  InputField.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Foundation

public enum InputField: Hashable, Equatable {
    case name
    case email
    case phoneNumber
    case password
    case confirmPassword
    
    var labelWidth: CGFloat {
        switch self {
        case .email: return 60
        case .password: return 95
        case .name: return 100
        case .confirmPassword: return 160
        case .phoneNumber: return 130
        }
    }
}
