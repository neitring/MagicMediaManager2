import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: MediaLibraryViewModel

    private var enabledCategories: [MediaCategory] {
        MediaCategory.allCases.filter { viewModel.categoriesEnabled[$0, default: true] }
    }

    var body: some View {
        TabView {
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "star")
            }

            ForEach(enabledCategories) { category in
                NavigationStack {
                    CategoryListView(category: category)
                }
                .tabItem {
                    Label(category.rawValue, systemImage: category.systemImage)
                }
            }

            NavigationStack {
                ManageView()
            }
            .tabItem {
                Label("Manage", systemImage: "slider.horizontal.3")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MediaLibraryViewModel())
}
