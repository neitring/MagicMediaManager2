import Foundation

struct CategorySettings: Codable, Hashable {
    var isEnabled: Bool
    var sources: [String]
}
