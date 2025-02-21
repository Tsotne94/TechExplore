//
//  CompanyModel.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

public struct CompanyModel: Codable {
    let name: String
    let address: String
    let numberOfStatements: Int
    let imageURL: String
}

#warning("take care of this")
//public struct Statement: Codable {
//    let category: Category
//    let title: String
//    let decription: String
//    let imageURLs: [String]
//    let isActive: Bool
//}

//public struct Category: Codable {
//    let id: Int
//    let title: String
//    let description: String
//}
//
//let categories: [Category] = [
//    Category(id: 1, title: "Physical", description: "People with physical disabilities"),
//    Category(id: 2, title: "Students", description: "Students with disabilities in education"),
//    Category(id: 3, title: "Veterans", description: "Veterans facing disabilities after service"),
//    Category(id: 4, title: "Blind", description: "Individuals who are blind or visually impaired"),
//    Category(id: 5, title: "Deaf", description: "Deaf or hard-of-hearing individuals"),
//    Category(id: 6, title: "Autism", description: "People with autism spectrum disorder"),
//    Category(id: 7, title: "Mental", description: "Individuals with mental health disabilities"),
//    Category(id: 8, title: "Wheelchair", description: "People using wheelchairs or mobility aids"),
//    Category(id: 9, title: "Cognitive", description: "People with cognitive or learning disabilities"),
//    Category(id: 10, title: "Speech", description: "Individuals with speech impairments")
//]

