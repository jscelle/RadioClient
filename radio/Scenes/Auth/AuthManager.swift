//
//  AuthManager.swift
//  radio
//
//  Created by Artem Raykh on 10.01.2024.
//

import Foundation

final actor AuthManager {
    
    private var user: User?
    static let shared = AuthManager()
    
    private init() { }
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    func getUser() -> User? {
        return user
    }
}
