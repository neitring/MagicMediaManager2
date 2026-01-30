import Combine
import Foundation
import SwiftUI

final class LibraryViewModel: ObservableObject {
    let categories: [MediaCategory]
    let items: [MediaItem]
    let favoritesStore: FavoritesStore
    let settingsStore: CategorySettingsStore

    private var cancellables: Set<AnyCancellable> = []

    init(service: MediaLibraryService = MediaLibraryService()) {
        self.categories = service.categories
        self.items = service.items
        let favoritesStore = FavoritesStore()
        let settingsStore = CategorySettingsStore(categories: service.categories)
        self.favoritesStore = favoritesStore
        self.settingsStore = settingsStore

        favoritesStore.objectWillChange
            .sink { [weak self] in self?.objectWillChange.send() }
            .store(in: &cancellables)

        settingsStore.objectWillChange
            .sink { [weak self] in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    func items(for category: MediaCategory) -> [MediaItem] {
        items.filter { $0.categoryID == category.id }
    }

    func favoriteItems() -> [MediaItem] {
        let favoriteLinks = favoritesStore.favorites
        var seen = Set<String>()
        let filtered = items.filter { favoriteLinks.contains($0.link) }
        let deduped = filtered.filter { item in
            if seen.contains(item.link) {
                return false
            }
            seen.insert(item.link)
            return true
        }
        return deduped.sorted { $0.title < $1.title }
    }

    func toggleFavorite(link: String) {
        favoritesStore.toggleFavorite(link: link)
    }

    func isFavorite(link: String) -> Bool {
        favoritesStore.isFavorited(link)
    }

    func settings(for category: MediaCategory) -> CategorySettings {
        settingsStore.settings(for: category.id)
    }

    func setCategoryEnabled(_ enabled: Bool, category: MediaCategory) {
        settingsStore.update(categoryID: category.id) { settings in
            settings.isEnabled = enabled
        }
    }

    func addSource(_ source: String, to category: MediaCategory) {
        let trimmed = source.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        settingsStore.update(categoryID: category.id) { settings in
            if !settings.sources.contains(trimmed) {
                settings.sources.append(trimmed)
            }
        }
    }

    func removeSources(at offsets: IndexSet, category: MediaCategory) {
        settingsStore.update(categoryID: category.id) { settings in
            settings.sources.remove(atOffsets: offsets)
        }
    }
}
