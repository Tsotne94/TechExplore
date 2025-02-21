//
//  UserSignUpModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Foundation

struct SignUpRequest: Codable {
    let email: String
    let password: String
    let confirmPassword: String
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case email, password
        case confirmPassword = "password2"
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case phoneNumber = "phone_number"
    }
}
