import Foundation

struct MediaItem: Identifiable, Hashable {
    let title: String
    let subtitle: String
    let link: String

    var id: String { link }
}

enum MediaCategory: String, CaseIterable, Identifiable {
    case tours = "Tours"
    case musicals = "Musicals"
    case albums = "Albums"
    case videoGames = "Video Games"
    case tvShows = "TV Shows"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .tours:
            return "map"
        case .musicals:
            return "theatermasks"
        case .albums:
            return "music.note.list"
        case .videoGames:
            return "gamecontroller"
        case .tvShows:
            return "tv"
        }
    }
}
