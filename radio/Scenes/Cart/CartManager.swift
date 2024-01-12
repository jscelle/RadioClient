//
//  CartManager.swift
//  radio
//
//  Created by Artem Raykh on 07.01.2024.
//

import Foundation
import Dependencies

@MainActor
class CartManager: ObservableObject {
    
    @Published var items: [Item] = []
    @Dependency(\.networkProvider) private var networkProvider
    @Dependency(\.logger) private var logger
    
    func addItem(_ item: Item) {
        items.append(item)
    }
    
    func makePurchase() async {
        do {
            
            guard let name = await AuthManager.shared.getUser()?.name else { return }
            
            let itemCounts = Dictionary(items.map { ($0.id, 1) }, uniquingKeysWith: +)
            
            // Make a purchase request for each unique item
            for (itemId, count) in itemCounts {
                try await networkProvider.request(.makePurchase(name: name, itemId: itemId, count: count)) as Empty
                
                await MainActor.run {
                    items.removeAll()
                }
            }
            
        } catch {
            logger.error("\(error)")
        }
    }
}

extension CartManager {
    var groupedItems: [String: (item: Item, count: Int)] {
        Dictionary(grouping: items, by: { $0.id })
            .mapValues { (items) -> (item: Item, count: Int) in
                (item: items[0], count: items.count)
            }
    }
}
