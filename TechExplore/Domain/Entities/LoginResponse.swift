//
//  LoginResponse.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

import Foundation

struct LoginResponse: Codable {
    let access: String
    let refresh: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case access, refresh
        case userId = "user_id"
    }
}
 
