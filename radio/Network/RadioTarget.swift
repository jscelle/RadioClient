//
//  AnimeTarget.swift
//  Animue
//
//  Created by Artem Raykh on 02.10.2023.
//

import Foundation

struct RadioTarget: Target {
    var url: URL
    
    var path: String
    
    var method: HTTPMethod
    
    var task: NetworkTask
    
    var headers: [String : String]?
    
    var authorizationHeaders: [String : String]?
}

extension RadioTarget {
    
    static func signUp(user: User) -> RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/signup",
            method: .post,
            task: .withParameters(
                parameters: [
                    "name": user.name,
                    "password": user.password,
                    "status": user.status!.rawValue
                ],
                encoding: JSONEncoding.default
            )
        )
    }
    
    static func logIn(user: User) -> RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/signin",
            method: .post,
            task: .withParameters(
                parameters: [
                    "name": user.name,
                    "password": user.password
                ],
                encoding: JSONEncoding.default
            )
        )
    }
    
    static var getCollections: RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/collections",
            method: .get,
            task: .plain
        )
    }
    
    static func getItemDetails(name: String) -> RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/items/\(name)",
            method: .get,
            task: .plain
        )
    }
    
    static func createCollection(name: String, title: String) -> RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/collections",
            method: .post,
            task: .withParameters(
                parameters: [
                    "name": name,
                    "title": title
                ],
                encoding: JSONEncoding.default
            )
        )
    }
    
    static func createItem(title: String, description: String, price: Double, currency: String) -> RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/items",
            method: .post,
            task: .withParameters(
                parameters: [
                    "title": title,
                    "description": description,
                    "price": price,
                    "currency": currency
                ],
                encoding: JSONEncoding.default
            )
        )
    }
    
    static func addItemToCollection(collectionName: String, itemId: String) -> RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/collections/\(collectionName)/items/\(itemId)",
            method: .post,
            task: .plain
        )
    }
    
    static func makePurchase(name: String, itemId: String, count: Int) -> RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/purchase",
            method: .post,
            task: .withParameters(
                parameters: [
                    "name": name,
                    "itemId": itemId,
                    "count": count
                ],
                encoding: JSONEncoding.default
            )
        )
    }
    
    static func getPurchaseHistory(username: String) -> RadioTarget {
        RadioTarget(
            url: Config.baseURL,
            path: "/purchases/\(username)",
            method: .get,
            task: .plain
        )
    }
    
    static func fetchStores() -> RadioTarget {
        .init(
            url: Config.baseURL,
            path: "/stores",
            method: .get,
            task: .plain
        )
    }
    
    static func addStore(store: Store) -> RadioTarget {
        .init(
            url: Config.baseURL,
            path: "/stores",
            method: .post,
            task: .withParameters(
                parameters: [
                    "name": store.name,
                    "latitude": store.latitude,
                    "longitude": store.longitude
                ],
                encoding: JSONEncoding.default
            )
        )
    }
    
    static func addUserToStore(storeId: String, userId: String) -> RadioTarget {
        .init(
            url: Config.baseURL,
            path: "/stores/\(storeId)/addUser",
            method: .post,
            task: .withParameters(
                parameters: [
                    "userId": userId,
                    "storeId": storeId
                ],
                encoding: JSONEncoding.default
            )
        )
    }
    
    static func getCollections(storeId: String) -> RadioTarget {
        .init(
            url: Config.baseURL,
            path: "/stores/\(storeId)/collections",
            method: .post,
            task: .plain
        )
    }
}

