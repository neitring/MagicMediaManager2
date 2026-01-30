import Foundation

struct MediaLibraryService {
    let categories: [MediaCategory]
    let items: [MediaItem]

    init(categories: [MediaCategory] = MediaCategory.all, items: [MediaItem]? = nil) {
        self.categories = categories
        if let items {
            self.items = items
        } else {
            self.items = MediaLibraryService.sampleItems
        }
    }

    private static let sampleItems: [MediaItem] = [
        MediaItem(
            title: "Midnight City Lights",
            subtitle: "Global Theater Guild · 12-city run",
            link: "https://example.com/tours/midnight-city-lights",
            categoryID: MediaCategory.tour.id
        ),
        MediaItem(
            title: "Harbor Moon Live",
            subtitle: "City Arts Council · Waterfront stage",
            link: "https://example.com/tours/harbor-moon-live",
            categoryID: MediaCategory.tour.id
        ),
        MediaItem(
            title: "Pulse of Paris",
            subtitle: "Travel Light Shows · International cast",
            link: "https://example.com/tours/pulse-of-paris",
            categoryID: MediaCategory.tour.id
        ),
        MediaItem(
            title: "Brighten the Avenue",
            subtitle: "Broadway Beat · Limited engagement",
            link: "https://example.com/musicals/brighten-the-avenue",
            categoryID: MediaCategory.musicals.id
        ),
        MediaItem(
            title: "Sea Glass Dreams",
            subtitle: "West End Spotlight · New score",
            link: "https://example.com/musicals/sea-glass-dreams",
            categoryID: MediaCategory.musicals.id
        ),
        MediaItem(
            title: "Signal & Spark",
            subtitle: "Stagecraft Weekly · Behind-the-scenes",
            link: "https://example.com/musicals/signal-and-spark",
            categoryID: MediaCategory.musicals.id
        ),
        MediaItem(
            title: "Aurora Tapes",
            subtitle: "Indie Pulse · Synthwave collection",
            link: "https://example.com/albums/aurora-tapes",
            categoryID: MediaCategory.albums.id
        ),
        MediaItem(
            title: "Concrete Seasons",
            subtitle: "Studio Sessions · Deluxe edition",
            link: "https://example.com/albums/concrete-seasons",
            categoryID: MediaCategory.albums.id
        ),
        MediaItem(
            title: "Neon Static",
            subtitle: "Fresh Tracks Radio · Listener favorite",
            link: "https://example.com/albums/neon-static",
            categoryID: MediaCategory.albums.id
        ),
        MediaItem(
            title: "Atlas Shift",
            subtitle: "Arcade Journal · Co-op adventure",
            link: "https://example.com/games/atlas-shift",
            categoryID: MediaCategory.videoGames.id
        ),
        MediaItem(
            title: "Garden of Gears",
            subtitle: "Questline Studio · Puzzle sandbox",
            link: "https://example.com/games/garden-of-gears",
            categoryID: MediaCategory.videoGames.id
        ),
        MediaItem(
            title: "Neon Fortress",
            subtitle: "Level Up Daily · Competitive update",
            link: "https://example.com/games/neon-fortress",
            categoryID: MediaCategory.videoGames.id
        ),
        MediaItem(
            title: "Riverline",
            subtitle: "ScreenTime Digest · Season 3 premiere",
            link: "https://example.com/tv/riverline",
            categoryID: MediaCategory.tvShows.id
        ),
        MediaItem(
            title: "Cityline Confidential",
            subtitle: "Binge Watchers · True crime doc",
            link: "https://example.com/tv/cityline-confidential",
            categoryID: MediaCategory.tvShows.id
        ),
        MediaItem(
            title: "Orbit Signal",
            subtitle: "Pilot Lounge · Sci-fi anthology",
            link: "https://example.com/tv/orbit-signal",
            categoryID: MediaCategory.tvShows.id
        )
    ]
}
