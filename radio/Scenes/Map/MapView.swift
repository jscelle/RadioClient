// radio/Scenes/MapView.swift

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    @State private var selectedStore: Store?
    @State private var navigate = false
    
    @StateObject var cartManager: CartManager
    
    var body: some View {
        NavigationView {
            
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.stores) { store in
                MapAnnotation(
                    coordinate:
                        .init(
                            latitude: store.latitude,
                            longitude: store.longitude
                        )
                ) {
                    VStack {
                        Text(store.name)
                            .foregroundStyle(.red)
                        
                        Circle()
                            .background(Color.red)
                    }
                    .onTapGesture {
                        selectedStore = store
                        navigate = true
                    }
                }
            }
            .sheet(isPresented: $navigate) {
                CatalogView(viewModel: .init(storeName: selectedStore?.name), cartManager: cartManager)
            }
            .navigationTitle("Stores")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddStoreView(viewModel: viewModel)) {
                        Text("Add Store")
                    }
                }
            }
        }
    }
}

import SwiftUI
import MapKit

struct AddStoreView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: MapViewModel
    @State private var name: String = ""
    @State private var selectedLocation: IdentifiableLocation?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 58.53503614664949, longitude: 31.26636812418378),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Form {
            TextField("Store Name", text: $name)
            
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: selectedLocation != nil ? [selectedLocation!] : []
            ) { location in
                MapMarker(coordinate: location.coordinate)
            }
            .frame(height: 300)
            .onTapGesture {
                let location = convertToCoordinate(from: region.center)
                selectedLocation = IdentifiableLocation(coordinate: location)
            }
            
            Button(action: addStore) {
                Text("Add Store")
            }
        }
        .onReceive(viewModel.$stores, perform: { _ in
            self.dismiss()
        })
        .navigationTitle("Add Store")
    }
    
    private func convertToCoordinate(from center: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
    }
    
    private func addStore() {
        guard let coordinate = selectedLocation?.coordinate else {
            return
        }
        
        Task {
            await viewModel.addStore(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}

struct IdentifiableLocation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}
