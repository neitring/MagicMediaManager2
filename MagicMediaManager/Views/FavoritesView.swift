import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var viewModel: MediaLibraryViewModel
    @State private var searchText = ""

    var body: some View {
        let favorites = viewModel.favoriteItems()
        let filteredFavorites = favorites.filter {
            searchText.isEmpty || viewModel.displayLine(for: $0).localizedCaseInsensitiveContains(searchText)
        }

        return Group {
            if viewModel.favorites.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No Favorites Yet")
                        .font(.headline)
                    Text("Tap the star on any item to collect it here.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                List {
                    ForEach(filteredFavorites) { item in
                        MediaRowView(item: item)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Favorites")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
            .environmentObject(MediaLibraryViewModel())
    }
}
