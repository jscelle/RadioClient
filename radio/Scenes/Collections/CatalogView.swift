import SwiftUI
import Combine


// Main View
struct CatalogView: View {
    @ObservedObject var viewModel = CatalogViewModel()
    @ObservedObject var cartManager: CartManager
    
    @State private var showingCreateCollection = false

    @State private var showRightItem = false
    
    var body: some View {
        NavigationView {
            List(viewModel.collections, id: \.name) { item in
                NavigationLink(
                    destination: DetailView(
                        collection: item, 
                        cartManager: cartManager
                    )
                    .environmentObject(ItemDetailViewModel(collection: item))
                ) {
                    Text(item.title)
                }
                .navigationBarTitle(item.title)
                .navigationBarItems(trailing: rightItem)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCollections()
            }
        }
        .sheet(isPresented: $showingCreateCollection) {
            CreateCollectionForm(viewModel: CollectionCreationViewModel())
        }
        .task {
            showRightItem = await AuthManager.shared.getUser()?.status == .admin
        }
    }
    
    @ViewBuilder
    private var rightItem: some View {
        if showRightItem {
            Button("Создать коллекцию") {
                showingCreateCollection = true
            }
        }
    }
}
