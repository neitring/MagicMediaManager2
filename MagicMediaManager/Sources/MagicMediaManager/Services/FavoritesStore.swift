import Combine
import Foundation
import SwiftUI

@MainActor
final class FavoritesStore: ObservableObject {
    @Published var favoriteLinks: Set<String>

    init(favoriteLinks: Set<String> = []) {
        self.favoriteLinks = favoriteLinks
    }
}
