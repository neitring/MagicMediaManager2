import Foundation

struct MediaItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let link: String
    let categoryID: String

    init(title: String, subtitle: String, link: String, categoryID: String) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.link = link
        self.categoryID = categoryID
    }
}
