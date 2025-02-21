//
//  UserModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

public struct User: Codable {
    let email: String
    let phone: String
    let status: [UserCategory]
    let individual: Individual
    
    enum CodingKeys: String, CodingKey {
        case email, status, individual
        case phone = "phone_number"
    }
}
