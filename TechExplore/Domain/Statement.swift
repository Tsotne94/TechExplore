//
//  Statement.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

public struct Statement: Codable {
    let id: Int
    let companyId: Int
    let category: Category
    let title: String
    let decription: String
    let imageURL: String
    let isActive: Bool
}
