//
//  Individual.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

struct Individual: Codable {
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
    }
}
