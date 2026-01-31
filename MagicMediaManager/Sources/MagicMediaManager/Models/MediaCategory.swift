import Foundation

struct MediaCategory: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let systemImage: String
    let defaultSources: [String]

    static let tour = MediaCategory(
        id: "tour",
        title: "Tour",
        systemImage: "map",
        defaultSources: ["Global Theater Guild", "City Arts Council", "Travel Light Shows"]
    )

    static let musicals = MediaCategory(
        id: "musicals",
        title: "Musicals",
        systemImage: "music.note.list",
        defaultSources: ["Broadway Beat", "West End Spotlight", "Stagecraft Weekly"]
    )

    static let albums = MediaCategory(
        id: "albums",
        title: "Albums",
        systemImage: "opticaldisc",
        defaultSources: ["Indie Pulse", "Studio Sessions", "Fresh Tracks Radio"]
    )

    static let videoGames = MediaCategory(
        id: "videoGames",
        title: "Video Games",
        systemImage: "gamecontroller",
        defaultSources: ["Arcade Journal", "Questline Studio", "Level Up Daily"]
    )

    static let tvShows = MediaCategory(
        id: "tvShows",
        title: "TV Shows",
        systemImage: "tv",
        defaultSources: ["ScreenTime Digest", "Binge Watchers", "Pilot Lounge"]
    )

    static let all: [MediaCategory] = [
        .tour,
        .musicals,
        .albums,
        .videoGames,
        .tvShows
    ]
}
