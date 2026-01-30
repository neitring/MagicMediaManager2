import SwiftUI

struct CategoryListView: View {
    let category: MediaCategory
    @EnvironmentObject private var viewModel: MediaLibraryViewModel

    private var isEnabled: Bool {
        viewModel.categoriesEnabled[category, default: true]
    }

    var body: some View {
        List {
            if isEnabled {
                ForEach(viewModel.itemsByCategory[category] ?? []) { item in
                    MediaRowView(item: item)
                }
            } else {
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "nosign")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("This category is disabled in Manage.")
                        .font(.headline)
                    Text("Enable it to see items again.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 24)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(category.rawValue)
    }
}

#Preview {
    NavigationStack {
        CategoryListView(category: .tours)
            .environmentObject(MediaLibraryViewModel())
    }
}
