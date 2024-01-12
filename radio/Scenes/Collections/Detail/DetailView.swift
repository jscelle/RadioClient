//
//  DetailView.swift
//  radio
//
//  Created by Artem Raykh on 10.01.2024.
//

import Foundation
import SwiftUI

struct DetailView: View {
    let collection: Collection
        
    @ObservedObject var cartManager: CartManager

    @EnvironmentObject var viewModel: ItemDetailViewModel
    
    @State private var showingCreateItem = false
    
    @State private var showRightItem = false
    
    var body: some View {
        List(viewModel.items, id: \.id) { item in
            ItemView(item: item, cartManager: cartManager)
        }
        .navigationBarTitle(collection.title, displayMode: .inline)
        
        .navigationBarItems(trailing: rightItem)
        .sheet(isPresented: $showingCreateItem) {
            CreateItemView(
                collectionName: collection.name,
                viewModel: CreateItemViewModel()) {
                    Task {
                        await viewModel.fetchItemDetails(for: viewModel.collection.name)
                    }
                }
        }
        .onAppear {
            Task {
                await viewModel.fetchItemDetails(for: viewModel.collection.name)
            }
        }
        .task {
            showRightItem = await AuthManager.shared.getUser()?.status != .user
        }
    }
    
    @ViewBuilder
    private var rightItem: some View {
        if showRightItem {
            Button("Создать товар") {
                showingCreateItem = true
            }
        }
    }
}

struct ItemView: View {
    
    let item: Item
    
    @ObservedObject var cartManager: CartManager
    
    var body: some View {
        VStack {
            Text(item.title)
                .font(.headline)
            Text("Price: \(item.price)")
                .font(.subheadline)
            
            Button(action: {
                cartManager.addItem(item)
            }) {
                Text("Add to Cart")
            }
        }
    }
}
