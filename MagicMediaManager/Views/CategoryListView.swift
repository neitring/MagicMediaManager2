import SwiftUI

struct CategoryListView: View {
    let category: MediaCategory
    @EnvironmentObject private var viewModel: MediaLibraryViewModel
    @State private var searchText = ""
    @State private var selectedFormats = Set(AlbumFormat.allCases)
    @State private var selectedServices = Set(StreamingService.allCases)
    @State private var selectedSystems = Set(GameSystem.allCases)
    @State private var zipCode = ""
    @State private var selectedDistance: DistanceOption = .fifty

    private var isEnabled: Bool {
        viewModel.categoriesEnabled[category, default: true]
    }

    private var filteredItems: [MediaItem] {
        let sources = viewModel.sourcesByCategory[category] ?? []
        let baseItems = (viewModel.itemsByCategory[category] ?? []).filter { item in
            sources.isEmpty || sources.contains(item.source)
        }

        let searchedItems = baseItems.filter { item in
            searchText.isEmpty || viewModel.displayLine(for: item).localizedCaseInsensitiveContains(searchText)
        }

        return searchedItems.filter { item in
            switch category {
            case .albums:
                guard let format = item.format else { return false }
                return selectedFormats.contains(format)
            case .moviesStreaming, .tv:
                guard let service = item.streamingService else { return false }
                return selectedServices.contains(service)
            case .videoGames:
                guard let system = item.gameSystem else { return false }
                return selectedSystems.contains(system)
            case .tours, .moviesTheatrical, .theater:
                guard !zipCode.isEmpty else { return true }
                return item.location?.localizedCaseInsensitiveContains(zipCode) == true
            }
        }
    }

    var body: some View {
        List {
            if isEnabled {
                Section {
                    switch category {
                    case .albums:
                        FormatFilterView(selectedFormats: $selectedFormats)
                    case .moviesStreaming, .tv:
                        StreamingFilterView(selectedServices: $selectedServices)
                    case .videoGames:
                        GameSystemFilterView(selectedSystems: $selectedSystems)
                    case .tours, .moviesTheatrical, .theater:
                        LocationFilterView(zipCode: $zipCode, selectedDistance: $selectedDistance)
                    }
                }
                .textCase(nil)

                ForEach(filteredItems) { item in
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
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

private struct FormatFilterView: View {
    @Binding var selectedFormats: Set<AlbumFormat>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Formats")
                .font(.headline)
            ForEach(AlbumFormat.allCases) { format in
                Toggle(format.rawValue, isOn: Binding(
                    get: { selectedFormats.contains(format) },
                    set: { isOn in
                        if isOn {
                            selectedFormats.insert(format)
                        } else {
                            selectedFormats.remove(format)
                        }
                    }
                ))
            }
        }
    }
}

private struct StreamingFilterView: View {
    @Binding var selectedServices: Set<StreamingService>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Streaming Services")
                .font(.headline)
            ForEach(StreamingService.allCases) { service in
                Toggle(service.rawValue, isOn: Binding(
                    get: { selectedServices.contains(service) },
                    set: { isOn in
                        if isOn {
                            selectedServices.insert(service)
                        } else {
                            selectedServices.remove(service)
                        }
                    }
                ))
            }
        }
    }
}

private struct GameSystemFilterView: View {
    @Binding var selectedSystems: Set<GameSystem>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Game Systems")
                .font(.headline)
            ForEach(GameSystem.allCases) { system in
                Toggle(system.rawValue, isOn: Binding(
                    get: { selectedSystems.contains(system) },
                    set: { isOn in
                        if isOn {
                            selectedSystems.insert(system)
                        } else {
                            selectedSystems.remove(system)
                        }
                    }
                ))
            }
        }
    }
}

private struct LocationFilterView: View {
    @Binding var zipCode: String
    @Binding var selectedDistance: DistanceOption

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location")
                .font(.headline)
            TextField("Zip code", text: $zipCode)
                .keyboardType(.numberPad)
            Picker("Distance", selection: $selectedDistance) {
                ForEach(DistanceOption.allCases) { option in
                    Text(option.label).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    NavigationStack {
        CategoryListView(category: .tours)
            .environmentObject(MediaLibraryViewModel())
    }
}
