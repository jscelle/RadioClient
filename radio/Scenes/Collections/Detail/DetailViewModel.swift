//
//  DetailViewModel.swift
//  radio
//
//  Created by Artem Raykh on 10.01.2024.
//

import Foundation
import Dependencies

final class ItemDetailViewModel: ObservableObject {
    @Dependency(\.networkProvider) private var networkProvider
    @Dependency(\.logger) private var logger
    
    @Published var items: [Item] = []
    
    let collection: Collection
    
    init(collection: Collection) {
        self.collection = collection
        Task {
            await fetchItemDetails(for: collection.name)
        }
    }
    
    func fetchItemDetails(for name: String) async {
        do {
            let items: [Item] = try await networkProvider.request(.getItemDetails(name: name))
            await MainActor.run {
                self.items = items
            }
        } catch {
            let errorDescription = String(describing: error)
            logger.error("\(errorDescription)")
        }
    }
}
