import Foundation

struct MediaItem: Identifiable, Hashable {
    let title: String
    let link: String
    let category: MediaCategory
    let releaseDate: Date
    let source: String
    let artistName: String?
    let location: String?
    let format: AlbumFormat?
    let streamingService: StreamingService?
    let gameSystem: GameSystem?
    let episodeNumber: String?

    var id: String { link }
}

enum AlbumFormat: String, CaseIterable, Identifiable {
    case vinyl = "Vinyl"
    case cd = "CD"
    case streaming = "Streaming"

    var id: String { rawValue }
}

enum StreamingService: String, CaseIterable, Identifiable {
    case netflix = "Netflix"
    case hulu = "Hulu"
    case primeVideo = "Prime Video"
    case disneyPlus = "Disney+"
    case max = "Max"
    case appleTV = "Apple TV+"

    var id: String { rawValue }
}

enum GameSystem: String, CaseIterable, Identifiable {
    case playStation5 = "PlayStation 5"
    case xboxSeries = "Xbox Series"
    case nintendoSwitch = "Nintendo Switch"
    case pc = "PC"

    var id: String { rawValue }
}

enum DistanceOption: Int, CaseIterable, Identifiable {
    case fifty = 50
    case oneHundred = 100
    case fiveHundred = 500

    var id: Int { rawValue }
    var label: String { "\(rawValue) miles" }
}

enum MediaCategory: String, CaseIterable, Identifiable {
    case tours = "Tours"
    case albums = "Albums"
    case videoGames = "Video Games"
    case moviesTheatrical = "Movies (Theatrical)"
    case moviesStreaming = "Movies (Streaming)"
    case tv = "TV"
    case theater = "Theater"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .tours:
            return "map"
        case .albums:
            return "music.note.list"
        case .videoGames:
            return "gamecontroller"
        case .moviesTheatrical:
            return "film"
        case .moviesStreaming:
            return "play.tv"
        case .tv:
            return "tv"
        case .theater:
            return "theatermasks"
        }
    }
}
