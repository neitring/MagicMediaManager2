import Combine
import Foundation

final class FavoritesStore: ObservableObject {
    @Published var favoriteLinks: Set<String>

    init(favoriteLinks: Set<String> = []) {
        self.favoriteLinks = favoriteLinks
    }
}
