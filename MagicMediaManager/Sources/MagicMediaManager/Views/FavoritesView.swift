import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var viewModel: LibraryViewModel

    var body: some View {
        NavigationStack {
            if viewModel.favoritesStore.favorites.isEmpty {
                EmptyStateView(
                    title: "No Favorites Yet",
                    message: "Tap the star on any item to collect it here."
                )
                .navigationTitle("Favorites")
            } else {
                List(viewModel.favoriteItems()) { item in
                    MediaItemRow(item: item)
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Favorites")
            }
        }
    }
}
