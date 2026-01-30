import Foundation
import SwiftUI

final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: Set<String> = []

    private let userDefaults: UserDefaults
    private let storageKey = "favoriteLinks"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        load()
    }

    func isFavorited(_ link: String) -> Bool {
        favorites.contains(link)
    }

    func toggleFavorite(link: String) {
        if favorites.contains(link) {
            favorites.remove(link)
        } else {
            favorites.insert(link)
        }
        save()
    }

    private func load() {
        guard let stored = userDefaults.array(forKey: storageKey) as? [String] else {
            favorites = []
            return
        }
        favorites = Set(stored)
    }

    private func save() {
        userDefaults.set(Array(favorites), forKey: storageKey)
    }
}
