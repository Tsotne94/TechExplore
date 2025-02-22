//
//  Statement.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

public struct Statement: Codable, Identifiable {
    public let id: Int
    let authorId: Int
    let content: String
    let imageURL: String
    let categories: [Category]
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, content, categories
        case authorId = "author"
        case imageURL = "image"
        case isActive = "is_active"
    }
}
