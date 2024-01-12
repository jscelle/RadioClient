//
//  PurchaseHistoryView.swift
//  radio
//
//  Created by Artem Raykh on 11.01.2024.
//

import Foundation
import SwiftUI

struct PurchaseHistoryView: View {
    @ObservedObject var purchaseHistoryViewModel: PurchaseHistoryViewModel
    
    var body: some View {
        List(purchaseHistoryViewModel.purchaseHistory, id: \.item.id) { purchase in
                HStack {
                    VStack {
                        Text(purchase.item.title)
                        Text(purchase.item.price.formatted())
                    }
                    
                    Text("Количество: \(purchase.count)")
                }
            }
            .navigationBarTitle("История покупок")
            .onAppear {
                Task {
                    await purchaseHistoryViewModel.fetchPurchaseHistory()
                }
            }
    }
}
