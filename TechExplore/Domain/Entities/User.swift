//
//  User.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 20.02.25.
//

public struct User: Codable {
    let uid: String
    let email: String?
    let displayName: String?
    let imageUrl: String?
    
    public init(uid: String, email: String? = nil, displayName: String? = nil, imageUrl: String? = nil) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.imageUrl = imageUrl
    }
    
    public init() {
        self.uid = ""
        self.email = nil
        self.displayName = nil
        self.imageUrl = nil
    }
}
