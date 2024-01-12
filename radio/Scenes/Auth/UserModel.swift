//
//  UserModel.swift
//  radio
//
//  Created by Artem Raykh on 07.12.2023.
//


import Foundation

struct User: Codable {
    
    let name: String
    let password: String
    let status: Status?
    
    enum Status: String, Codable {
        case user
        case admin
        case seller
    }
}

struct Empty: Decodable { }

extension User.Status: CaseIterable { }
