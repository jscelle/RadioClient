//
//  AuthViewModel.swift
//  radio
//
//  Created by Artem Raykh on 07.12.2023.
//

import Foundation
import Dependencies

final class AuthViewModel: ObservableObject {
    @Dependency(\.networkProvider) private var networkProvider
    @Dependency(\.logger) private var logger

    @Published var navigate = false

    func signUp(username: String, password: String, status: User.Status) async {
        do {
            let user: User = try await networkProvider.request(
                .signUp(
                    user: .init(
                        name: username,
                        password: password,
                        status: status
                    )
                )
            )
            
            await MainActor.run {
                navigate = true
            }
            
            await AuthManager.shared.setUser(user)
                        
        } catch {
            let errorDescription = String(describing: error)
            logger.error("\(errorDescription)")
        }
    }

    func signIn(username: String, password: String) async {
        do {
            let user: User = try await networkProvider.request(
                .logIn(
                    user: .init(
                        name: username,
                        password: password,
                        status: nil
                    )
                )
            )
            
            await MainActor.run {
                navigate = true
            }
            
            await AuthManager.shared.setUser(user)
            
        } catch {
            let errorDescription = String(describing: error)
            logger.error("\(errorDescription)")
        }
    }
}
