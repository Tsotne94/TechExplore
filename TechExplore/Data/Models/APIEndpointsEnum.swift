//
//  APIEndpoints.swift
//  TechExplore
//
//  Created by Cotne Chubinidze on 21.02.25.
//

enum APIEndpointsEnum {
    static let base = "http://3.72.251.137:8000/"
    static let login = "http://3.72.251.137:8000/user/login/"
    static let signUp = "http://3.72.251.137:8000/user/signup/"
    static let refresh = "http://3.72.251.137:8000/user/refresh/"
    static let currentUser = "http://3.72.251.137:8000/user/currentuser/"
    static let statement = "http://3.72.251.137:8000/post/"
    static let specificPost = "http://3.72.251.137:8000/post/" //+id then // id / apply/
    static let categories = "http://3.72.251.137:8000/post/category/"
}
