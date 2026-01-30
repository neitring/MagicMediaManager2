import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var viewModel: MediaLibraryViewModel

    var body: some View {
        Group {
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
                    ForEach(viewModel.favoriteItems()) { item in
                        MediaRowView(item: item)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
            .environmentObject(MediaLibraryViewModel())
    }
}
