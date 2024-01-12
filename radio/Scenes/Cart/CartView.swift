//
//  CartView.swift
//  radio
//
//  Created by Artem Raykh on 07.01.2024.
//

import Foundation
import SwiftUI
import Combine

// Assuming CartManager and CatalogItem are defined as before

// Cart View
struct CartView: View {
    @ObservedObject var cartManager: CartManager
    
    var body: some View {
        VStack {
            topItem
            
            List(cartManager.groupedItems.keys.sorted(), id: \.self) { key in
                if let groupedItem = cartManager.groupedItems[key] {
                    HStack {
                        ItemView(item: groupedItem.item, cartManager: cartManager)
                        // Implement CartItemView as needed
                        Spacer()
                        Text("Количество: \(groupedItem.count)")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        cartManager.items.remove(atOffsets: offsets)
    }
    
    private var topItem: some View {
        HStack {
            Button {
            
                Task {
                    await cartManager.makePurchase()
                }
                
            } label: {
                Image(systemName: "cart")
            }
            
            Spacer()
            
            NavigationLink {
                PurchaseHistoryView(
                    purchaseHistoryViewModel: PurchaseHistoryViewModel()
                )
            } label: {
                Image(systemName: "book")
            }
        }
    }
}
