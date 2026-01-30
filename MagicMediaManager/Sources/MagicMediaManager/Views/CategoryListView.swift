import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var viewModel: LibraryViewModel
    let category: MediaCategory

    var body: some View {
        NavigationStack {
            if viewModel.settings(for: category).isEnabled {
                List(viewModel.items(for: category)) { item in
                    MediaItemRow(item: item)
                }
                .listStyle(.insetGrouped)
                .navigationTitle(category.title)
            } else {
                EmptyStateView(
                    title: "\(category.title) Disabled",
                    message: "Enable this category in Manage to see its feed."
                )
                .navigationTitle(category.title)
            }
        }
    }
}
