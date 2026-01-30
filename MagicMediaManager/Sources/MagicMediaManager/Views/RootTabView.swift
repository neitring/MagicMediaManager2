import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var viewModel: LibraryViewModel

    var body: some View {
        TabView {
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }

            ForEach(viewModel.categories) { category in
                CategoryListView(category: category)
                    .tabItem {
                        Label(category.title, systemImage: category.systemImage)
                    }
            }

            ManageView()
                .tabItem {
                    Label("Manage", systemImage: "slider.horizontal.3")
                }
        }
    }
}
