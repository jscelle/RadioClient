//
//  CollectionViewModel.swift
//  radio
//
//  Created by Artem Raykh on 10.01.2024.
//

import Foundation
import Dependencies

// Catalog View Model
final class CatalogViewModel: ObservableObject {
    @Dependency(\.networkProvider) private var networkProvider
    @Dependency(\.logger) private var logger
    
    @Published var collections: [Collection] = []
    
    init() {
        Task {
            await fetchCollections()
        }
    }
    
    func fetchCollections() async {
        do {
            let collections: [Collection] = try await networkProvider.request(.getCollections)
            await MainActor.run {
                self.collections = collections
            }
        } catch {
            let errorDescription = String(describing: error)
            logger.error("\(errorDescription)")
        }
    }
}
