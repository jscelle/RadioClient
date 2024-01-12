//
//  PurchaseHistoryViewModel.swift
//  radio
//
//  Created by Artem Raykh on 11.01.2024.
//

import Dependencies
import Foundation
import Combine

final class PurchaseHistoryViewModel: ObservableObject {
    @Dependency(\.networkProvider) private var networkProvider
    @Dependency(\.logger) private var logger
    
    @Published var purchaseHistory: [Purchase] = []

    func fetchPurchaseHistory() async {
        do {
            guard let name = await AuthManager.shared.getUser()?.name else { return }
            
            let history: [Purchase] = try await networkProvider.request(.getPurchaseHistory(username: name))
            await MainActor.run {
                self.purchaseHistory = history
            }
        } catch {
            logger.error("\(error)")
        }
    }
}

struct Purchase: Codable {
    let item: Item
    let count: Int
}
