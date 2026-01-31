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

        let now = Date()
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: now) ?? now
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: now) ?? now

        return uniqueItems.values.sorted { lhs, rhs in
            let lhsBucket = favoriteBucket(for: lhs, oneDayAgo: oneDayAgo, oneYearAgo: oneYearAgo)
            let rhsBucket = favoriteBucket(for: rhs, oneDayAgo: oneDayAgo, oneYearAgo: oneYearAgo)
            if lhsBucket != rhsBucket {
                return lhsBucket < rhsBucket
            }
            if lhs.releaseDate != rhs.releaseDate {
                return lhs.releaseDate > rhs.releaseDate
            }
            let titleComparison = lhs.title.localizedCaseInsensitiveCompare(rhs.title)
            if titleComparison == .orderedSame {
                return lhs.link < rhs.link
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
        addItemForSource(trimmed, category: category)
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

    func displayLine(for item: MediaItem) -> String {
        let dateText = Self.dateFormatter.string(from: item.releaseDate)
        switch item.category {
        case .albums:
            let artist = item.artistName ?? "Unknown Artist"
            let format = item.format?.rawValue ?? "Format"
            return "\(dateText) - \(artist) - \(item.title) (\(format))"
        case .tours:
            let artist = item.artistName ?? item.title
            let location = item.location ?? "Location"
            return "\(dateText) - \(artist) (\(location))"
        case .moviesTheatrical:
            let location = item.location ?? "Theater"
            return "\(dateText) - \(item.title) (\(location))"
        case .moviesStreaming:
            let service = item.streamingService?.rawValue ?? "Service"
            return "\(dateText) - \(item.title) (\(service))"
        case .tv:
            let episode = item.episodeNumber ?? "Episode"
            let service = item.streamingService?.rawValue ?? "Service"
            return "\(dateText) - \(item.title) - \(episode) (\(service))"
        case .theater:
            let location = item.location ?? "Venue"
            return "\(dateText) - \(item.title) (\(location))"
        case .videoGames:
            let system = item.gameSystem?.rawValue ?? "System"
            return "\(dateText) - \(item.title) (\(system))"
        }
    }

    private func addItemForSource(_ source: String, category: MediaCategory) {
        let normalizedLink = "source-\(category.rawValue.lowercased().replacingOccurrences(of: " ", with: "-"))-\(source.lowercased().replacingOccurrences(of: " ", with: "-"))"
        let existingLinks = itemsByCategory[category]?.map(\.link) ?? []
        guard existingLinks.contains(normalizedLink) == false else { return }
        let newItem = MediaItem(
            title: "\(source) Update",
            link: normalizedLink,
            category: category,
            releaseDate: Date(),
            source: source,
            artistName: category == .tours || category == .albums ? source : nil,
            location: category == .tours || category == .moviesTheatrical || category == .theater ? "Near You" : nil,
            format: category == .albums ? .streaming : nil,
            streamingService: category == .moviesStreaming || category == .tv ? .netflix : nil,
            gameSystem: category == .videoGames ? .pc : nil,
            episodeNumber: category == .tv ? "Episode 1" : nil
        )
        var items = itemsByCategory[category] ?? []
        items.insert(newItem, at: 0)
        itemsByCategory[category] = items
    }

    private func favoriteBucket(for item: MediaItem, oneDayAgo: Date, oneYearAgo: Date) -> Int {
        if item.releaseDate >= oneDayAgo {
            return 0
        }
        if item.releaseDate >= oneYearAgo {
            return 2
        }
        return 1
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    private static func sampleItems() -> [MediaCategory: [MediaItem]] {
        [
            .tours: [
                MediaItem(
                    title: "Starlight World Tour",
                    link: "tour-starlight-world",
                    category: .tours,
                    releaseDate: makeDate(daysFromNow: 10),
                    source: "Live Nation",
                    artistName: "Nova Echo",
                    location: "Seattle, WA 98101",
                    format: nil,
                    streamingService: nil,
                    gameSystem: nil,
                    episodeNumber: nil
                ),
                MediaItem(
                    title: "Echoes in Motion",
                    link: "tour-echoes-motion",
                    category: .tours,
                    releaseDate: makeDate(daysFromNow: -2),
                    source: "TicketMaster",
                    artistName: "Skyline Rush",
                    location: "Portland, OR 97205",
                    format: nil,
                    streamingService: nil,
                    gameSystem: nil,
                    episodeNumber: nil
                )
            ],
            .albums: [
                MediaItem(
                    title: "Solar Bloom",
                    link: "album-solar-bloom",
                    category: .albums,
                    releaseDate: makeDate(daysFromNow: 3),
                    source: "Bandcamp",
                    artistName: "Aurora Vale",
                    location: nil,
                    format: .vinyl,
                    streamingService: nil,
                    gameSystem: nil,
                    episodeNumber: nil
                ),
                MediaItem(
                    title: "Velvet Horizon",
                    link: "album-velvet-horizon",
                    category: .albums,
                    releaseDate: makeDate(daysFromNow: -30),
                    source: "Spotify",
                    artistName: "Glass Harbor",
                    location: nil,
                    format: .streaming,
                    streamingService: nil,
                    gameSystem: nil,
                    episodeNumber: nil
                ),
                MediaItem(
                    title: "Midnight Drive",
                    link: "album-midnight-drive",
                    category: .albums,
                    releaseDate: makeDate(daysFromNow: 40),
                    source: "Spotify",
                    artistName: "Neon Harbor",
                    location: nil,
                    format: .cd,
                    streamingService: nil,
                    gameSystem: nil,
                    episodeNumber: nil
                )
            ],
            .videoGames: [
                MediaItem(
                    title: "Moonforge",
                    link: "game-moonforge",
                    category: .videoGames,
                    releaseDate: makeDate(daysFromNow: 20),
                    source: "IGN",
                    artistName: nil,
                    location: nil,
                    format: nil,
                    streamingService: nil,
                    gameSystem: .playStation5,
                    episodeNumber: nil
                ),
                MediaItem(
                    title: "Circuit Drift",
                    link: "game-circuit-drift",
                    category: .videoGames,
                    releaseDate: makeDate(daysFromNow: -5),
                    source: "Steam",
                    artistName: nil,
                    location: nil,
                    format: nil,
                    streamingService: nil,
                    gameSystem: .pc,
                    episodeNumber: nil
                )
            ],
            .moviesTheatrical: [
                MediaItem(
                    title: "Silver Skies",
                    link: "movie-silver-skies",
                    category: .moviesTheatrical,
                    releaseDate: makeDate(daysFromNow: 7),
                    source: "AMC",
                    artistName: nil,
                    location: "San Francisco, CA 94103",
                    format: nil,
                    streamingService: nil,
                    gameSystem: nil,
                    episodeNumber: nil
                )
            ],
            .moviesStreaming: [
                MediaItem(
                    title: "Neon Horizon",
                    link: "movie-neon-horizon",
                    category: .moviesStreaming,
                    releaseDate: makeDate(daysFromNow: -1),
                    source: "Netflix",
                    artistName: nil,
                    location: nil,
                    format: nil,
                    streamingService: .netflix,
                    gameSystem: nil,
                    episodeNumber: nil
                )
            ],
            .tv: [
                MediaItem(
                    title: "Harbor Lights",
                    link: "tv-harbor-lights",
                    category: .tv,
                    releaseDate: makeDate(daysFromNow: 14),
                    source: "Hulu",
                    artistName: nil,
                    location: nil,
                    format: nil,
                    streamingService: .hulu,
                    gameSystem: nil,
                    episodeNumber: "Episode 2"
                )
            ],
            .theater: [
                MediaItem(
                    title: "Midnight Train",
                    link: "theater-midnight-train",
                    category: .theater,
                    releaseDate: makeDate(daysFromNow: 21),
                    source: "Broadway World",
                    artistName: nil,
                    location: "New York, NY 10019",
                    format: nil,
                    streamingService: nil,
                    gameSystem: nil,
                    episodeNumber: nil
                )
            ]
        ]
    }

    private static func defaultSources() -> [MediaCategory: [String]] {
        [
            .tours: ["TicketMaster", "Live Nation"],
            .albums: ["Bandcamp", "Spotify"],
            .videoGames: ["IGN", "Steam"],
            .moviesTheatrical: ["AMC", "Regal"],
            .moviesStreaming: ["Netflix", "Hulu", "Prime Video"],
            .tv: ["Hulu", "Disney+"],
            .theater: ["Playbill", "Broadway World"]
        ]
    }

    private static func makeDate(daysFromNow: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: daysFromNow, to: Date()) ?? Date()
    }
}
