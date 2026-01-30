import Foundation

final class CategorySettingsStore: ObservableObject {
    @Published private(set) var settings: [String: CategorySettings] = [:]

    private let userDefaults: UserDefaults
    private let storageKey = "categorySettings"

    init(categories: [MediaCategory], userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        load(categories: categories)
    }

    func update(categoryID: String, update: (inout CategorySettings) -> Void) {
        var current = settings[categoryID] ?? CategorySettings(isEnabled: true, sources: [])
        update(&current)
        settings[categoryID] = current
        save()
    }

    func settings(for categoryID: String) -> CategorySettings {
        settings[categoryID] ?? CategorySettings(isEnabled: true, sources: [])
    }

    private func load(categories: [MediaCategory]) {
        if let data = userDefaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: CategorySettings].self, from: data) {
            settings = decoded
        }

        for category in categories {
            if settings[category.id] == nil {
                settings[category.id] = CategorySettings(isEnabled: true, sources: category.defaultSources)
            }
        }
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        userDefaults.set(data, forKey: storageKey)
    }
}
