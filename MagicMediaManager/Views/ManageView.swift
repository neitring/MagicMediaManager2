import SwiftUI

struct ManageView: View {
    @EnvironmentObject private var viewModel: MediaLibraryViewModel
    @State private var newSources: [MediaCategory: String] = [:]

    var body: some View {
        List {
            ForEach(MediaCategory.allCases) { category in
                Section {
                    Toggle("Enabled", isOn: binding(for: category))

                    let sources = viewModel.sourcesByCategory[category] ?? []
                    if sources.isEmpty {
                        Text("No sources yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(sources, id: \.self) { source in
                            Text(source)
                        }
                        .onDelete { offsets in
                            viewModel.removeSource(at: offsets, from: category)
                        }
                    }

                    HStack {
                        TextField("Add source", text: newSourceBinding(for: category))
                        Button("Add") {
                            let source = newSources[category, default: ""]
                            viewModel.addSource(source, to: category)
                            newSources[category] = ""
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } header: {
                    Text(category.rawValue)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Manage")
    }

    private func binding(for category: MediaCategory) -> Binding<Bool> {
        Binding(
            get: { viewModel.categoriesEnabled[category, default: true] },
            set: { viewModel.categoriesEnabled[category] = $0 }
        )
    }

    private func newSourceBinding(for category: MediaCategory) -> Binding<String> {
        Binding(
            get: { newSources[category, default: ""] },
            set: { newSources[category] = $0 }
        )
    }
}

#Preview {
    NavigationStack {
        ManageView()
            .environmentObject(MediaLibraryViewModel())
    }
}
