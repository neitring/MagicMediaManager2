import Combine
import Foundation
import SwiftUI

final class MediaLibraryViewModel: ObservableObject {
    @Published private(set) var itemsByCategory: [MediaCategory: [MediaItem]] = [:]
    @Published private(set) var favorites: Set<String> = [] {
        didSet { saveFavorites() }
    }
    @Published var categoriesEnabled: [MediaCategory: Bool] = [:] {
        didSet { saveCategoriesEnabled() }
    }
    @Published var sourcesByCategory: [MediaCategory: [String]] = [:] {
        didSet { saveSources() }
    }

    private let favoritesKey = "favorites"
    private let categoriesEnabledKey = "categoriesEnabled"
    private let sourcesKey = "sourcesByCategory"

    init() {
        itemsByCategory = Self.sampleItems()
        categoriesEnabled = Dictionary(uniqueKeysWithValues: MediaCategory.allCases.map { ($0, true) })
        sourcesByCategory = Self.defaultSources()
        loadFavorites()
        loadCategoriesEnabled()
        loadSources()
    }

    func isFavorite(_ item: MediaItem) -> Bool {
        favorites.contains(item.link)
    }

    func toggleFavorite(_ item: MediaItem) {
        if favorites.contains(item.link) {
            favorites.remove(item.link)
        } else {
            favorites.insert(item.link)
        }
    }

    func favoriteItems() -> [MediaItem] {
        let uniqueItems = itemsByCategory.values
            .flatMap { $0 }
            .filter { favorites.contains($0.link) }
            .reduce(into: [String: MediaItem]()) { result, item in
                result[item.link] = item
            }

        return uniqueItems.values.sorted {
            let titleComparison = $0.title.localizedCaseInsensitiveCompare($1.title)
            if titleComparison == .orderedSame {
                return $0.link < $1.link
            }
            return titleComparison == .orderedAscending
        }
    }

    func addSource(_ source: String, to category: MediaCategory) {
        let trimmed = source.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var sources = sourcesByCategory[category] ?? []
        guard sources.contains(trimmed) == false else { return }
        sources.append(trimmed)
        sourcesByCategory[category] = sources
    }

    func removeSource(at offsets: IndexSet, from category: MediaCategory) {
        var sources = sourcesByCategory[category] ?? []
        sources.remove(atOffsets: offsets)
        sourcesByCategory[category] = sources
    }

    private func loadFavorites() {
        let stored = UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
        favorites = Set(stored)
    }

    private func saveFavorites() {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }

    private func loadCategoriesEnabled() {
        guard let data = UserDefaults.standard.data(forKey: categoriesEnabledKey) else { return }
        if let decoded = try? JSONDecoder().decode([String: Bool].self, from: data) {
            for (key, value) in decoded {
                if let category = MediaCategory(rawValue: key) {
                    categoriesEnabled[category] = value
                }
            }
        }
    }

    private func saveCategoriesEnabled() {
        let encoded = Dictionary(uniqueKeysWithValues: categoriesEnabled.map { ($0.key.rawValue, $0.value) })
        if let data = try? JSONEncoder().encode(encoded) {
            UserDefaults.standard.set(data, forKey: categoriesEnabledKey)
        }
    }

    private func loadSources() {
        guard let data = UserDefaults.standard.data(forKey: sourcesKey) else { return }
        if let decoded = try? JSONDecoder().decode([String: [String]].self, from: data) {
            for (key, value) in decoded {
                if let category = MediaCategory(rawValue: key) {
                    sourcesByCategory[category] = value
                }
            }
        }
    }

    private func saveSources() {
        let encoded = Dictionary(uniqueKeysWithValues: sourcesByCategory.map { ($0.key.rawValue, $0.value) })
        if let data = try? JSONEncoder().encode(encoded) {
            UserDefaults.standard.set(data, forKey: sourcesKey)
        }
    }

    private static func sampleItems() -> [MediaCategory: [MediaItem]] {
        [
            .tours: [
                MediaItem(title: "Starlight World Tour", subtitle: "2026 · Arena", link: "tour-starlight-world"),
                MediaItem(title: "Echoes in Motion", subtitle: "2025 · Stadium", link: "tour-echoes-motion")
            ],
            .musicals: [
                MediaItem(title: "Neon City", subtitle: "Broadway", link: "musical-neon-city"),
                MediaItem(title: "Midnight Train", subtitle: "West End", link: "musical-midnight-train")
            ],
            .albums: [
                MediaItem(title: "Solar Bloom", subtitle: "LP · 2024", link: "album-solar-bloom"),
                MediaItem(title: "Velvet Horizon", subtitle: "EP · 2023", link: "album-velvet-horizon")
            ],
            .videoGames: [
                MediaItem(title: "Moonforge", subtitle: "RPG", link: "game-moonforge"),
                MediaItem(title: "Circuit Drift", subtitle: "Racing", link: "game-circuit-drift")
            ],
            .tvShows: [
                MediaItem(title: "Harbor Lights", subtitle: "Drama", link: "tv-harbor-lights"),
                MediaItem(title: "Signal Lost", subtitle: "Sci-Fi", link: "tv-signal-lost")
            ]
        ]
    }

    private static func defaultSources() -> [MediaCategory: [String]] {
        [
            .tours: ["TicketMaster", "Live Nation"],
            .musicals: ["Playbill", "Broadway World"],
            .albums: ["Bandcamp", "Spotify"],
            .videoGames: ["IGN", "Steam"],
            .tvShows: ["IMDb", "Rotten Tomatoes"]
        ]
    }
}
