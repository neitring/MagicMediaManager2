import SwiftUI

struct ManageView: View {
    @EnvironmentObject private var viewModel: LibraryViewModel
    @State private var newSourceText: [String: String] = [:]

    var body: some View {
        NavigationStack {
            List {
                Section("Categories") {
                    ForEach(viewModel.categories) { category in
                        Toggle(
                            isOn: Binding(
                                get: { viewModel.settings(for: category).isEnabled },
                                set: { viewModel.setCategoryEnabled($0, category: category) }
                            )
                        ) {
                            Label(category.title, systemImage: category.systemImage)
                        }
                    }
                }

                ForEach(viewModel.categories) { category in
                    Section("Sources · \(category.title)") {
                        let sources = viewModel.settings(for: category).sources
                        if sources.isEmpty {
                            Text("No sources yet. Add one below.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(sources, id: \.self) { source in
                                Text(source)
                            }
                            .onDelete { offsets in
                                viewModel.removeSources(at: offsets, category: category)
                            }
                        }

                        HStack {
                            TextField("Add source", text: binding(for: category.id))
                                .textInputAutocapitalization(.words)
                            Button {
                                viewModel.addSource(binding(for: category.id).wrappedValue, to: category)
                                newSourceText[category.id] = ""
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                            .accessibilityLabel("Add source for \(category.title)")
                        }
                    }
                }
            }
            .navigationTitle("Manage")
        }
    }

    private func binding(for categoryID: String) -> Binding<String> {
        Binding(
            get: { newSourceText[categoryID, default: ""] },
            set: { newSourceText[categoryID] = $0 }
        )
    }
}
