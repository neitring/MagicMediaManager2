import SwiftUI

struct MediaItemRow: View {
    @EnvironmentObject private var viewModel: LibraryViewModel
    let item: MediaItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            FavoriteButton(isFavorite: viewModel.isFavorite(link: item.link)) {
                viewModel.toggleFavorite(link: item.link)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(item.link)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
