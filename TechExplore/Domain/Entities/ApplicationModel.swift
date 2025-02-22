//
//  ApplicationModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 22.02.25.
//

public struct ApplicationModel: Codable {
    let id: Int
    let creationDate: String?
    let updateDate: String?
    let status: Status?
    let userId: Int?
    let postId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case creationDate = "created_at"
        case updateDate = "updated_at"
        case status
        case userId = "user"
        case postId = "post"
    }
}
