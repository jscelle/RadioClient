//
//  CollectionCreationViewModel.swift
//  radio
//
//  Created by Artem Raykh on 10.01.2024.
//

import Foundation
import Dependencies

final class CollectionCreationViewModel: ObservableObject {
    @Dependency(\.networkProvider) private var networkProvider
    @Dependency(\.logger) private var logger
    
    @Published var collections: [Collection] = []
    
    func createCollection(title: String) async {
        do {
            guard let name = await AuthManager.shared.getUser()?.name else { return }
            
            let _: Collection = try await networkProvider.request(.createCollection(name: "Test", title: title))
        } catch {
            logger.error("\(error)")
        }
    }
}

final class CreateItemViewModel: ObservableObject {
    @Dependency(\.networkProvider) private var networkProvider
    @Dependency(\.logger) private var logger
    
    func createItem(title: String, description: String, price: Double, currency: String, in collectionName: String) async {
        do {
            let newItem: Item = try await networkProvider.request(
                .createItem(title: title, description: description, price: price, currency: currency)
            )
            await addItemToCollection(itemId: newItem.id, to: collectionName)
        } catch {
            logger.error("\(error)")
        }
    }
    
    func addItemToCollection(itemId: String, to collectionName: String) async {
        do {
            let a: Empty = try await networkProvider.request(.addItemToCollection(collectionName: collectionName, itemId: itemId))
        } catch {
            logger.error("\(error)")
        }
    }
}

