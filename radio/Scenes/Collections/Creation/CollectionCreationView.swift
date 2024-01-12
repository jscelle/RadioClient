//
//  CollectionCreation.swift
//  radio
//
//  Created by Artem Raykh on 10.01.2024.
//

import Foundation
import SwiftUI

struct CreateCollectionForm: View {
    @ObservedObject var viewModel: CollectionCreationViewModel
    @State private var title: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Новая коллекция")) {
                TextField("Название", text: $title)
                Button("Создать") {
                    Task {
                        await viewModel.createCollection(title: title)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CreateItemView: View {
    let collectionName: String
    @StateObject var viewModel = CreateItemViewModel()
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var price: String = ""
    @State private var currency: String = "Р" // Assuming currency is always Ruble

    @Environment(\.dismiss) private var dismiss
    
    let onDismiss: () -> ()
    
    var body: some View {
        Form {
            Section(header: Text("Создать товар в \(collectionName)")) {
                TextField("Название", text: $title)
                TextField("Описание", text: $description)
                TextField("Цена", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Валюта", text: $currency)
                Button("Создать товар") {
                    Task {
                        if let priceValue = Double(price) {
                            await viewModel.createItem(
                                title: title,
                                description: description,
                                price: priceValue,
                                currency: currency,
                                in: collectionName
                            )
                            
                            dismiss()
                            
                            onDismiss()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Новый товар")
    }
}
