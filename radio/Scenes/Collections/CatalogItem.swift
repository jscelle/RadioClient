//
//  CatalogItem.swift
//  radio
//
//  Created by Artem Raykh on 10.01.2024.
//

import Foundation

// Catalog Item Model
struct Collection: Codable {
    let name: String
    let title: String
}

// SubItem Model
struct Item: Codable {
    let id: String
    let title: String
    let description: String
    let price: Double
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case id = "itemId"
        case title
        case description
        case price
        case currency
    }
}
