import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "star")
            }

            ForEach(MediaCategory.allCases) { category in
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
