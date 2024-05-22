//
//  MapViewModel.swift
//  radio
//
//  Created by Artem Raykh on 19.05.2024.
//

import Foundation
import Combine
import MapKit
import Dependencies


class MapViewModel: ObservableObject {
    @Published var stores: [Store] = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 58.53503614664949, longitude: 31.26636812418378),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Dependency(\.networkProvider) private var networkProvider
    @Dependency(\.logger) private var logger
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        Task {
            await fetchStores()
        }
    }
    
    func fetchStores() async {
        do {
            let stores = try await networkProvider.request(.fetchStores()) as [Store]
            
            await MainActor.run {
                self.stores = stores
            }
        } catch {
            logger.error("Ошибка получения \(error)")
        }
    }
    
    func addStore(name: String, latitude: Double, longitude: Double) async {
        do {
            let store = try await networkProvider.request(
                .addStore(store: .init(name: name, latitude: latitude, longitude: longitude))
            ) as Store
            
            stores.append(store)
        } catch {
            logger.error("Ошибка получения \(error)")
        }
    }
    
    func addUserToStore(storeId: String, userId: String) async {
        
        do {
            self.stores = try await networkProvider.request(
                .addUserToStore(
                    storeId: storeId,
                    userId: userId
                )
            )
        } catch {
            logger.error("Ошибка получения \(error)")
        }
        
    }
}
