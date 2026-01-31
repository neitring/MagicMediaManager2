import Combine
import Foundation

final class CategorySettingsStore: ObservableObject {
    @Published var enabledCategories: [MediaCategory: Bool]

    init(enabledCategories: [MediaCategory: Bool] = Dictionary(uniqueKeysWithValues: MediaCategory.allCases.map { ($0, true) })) {
        self.enabledCategories = enabledCategories
    }
}
