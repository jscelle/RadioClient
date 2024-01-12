//
//  AppTabBarView.swift
//  radio
//
//  Created by Artem Raykh on 07.01.2024.
//

import SwiftUI

struct AppTabView: View {
    @ObservedObject var cartManager = CartManager()
    
    var body: some View {
        TabView {
            CatalogView(cartManager: cartManager)
                .tabItem {
                    Label("Catalog", systemImage: "list.dash")
                }
            
            CartView(cartManager: cartManager)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .badge(cartManager.items.count)
        }
    }
}

#Preview {
    AppTabView()
}
