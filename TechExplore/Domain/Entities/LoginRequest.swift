//
//  UserLoginModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}
