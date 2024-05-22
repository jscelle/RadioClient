//
//  Store.swift
//  radio
//
//  Created by Artem Raykh on 19.05.2024.
//

import Foundation
import MapKit

struct Store: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Store: Identifiable  {
    var id: String {
        name
    }
}
