import SwiftUI

struct MediaRowView: View {
    let item: MediaItem
    @EnvironmentObject private var viewModel: MediaLibraryViewModel

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                    viewModel.toggleFavorite(item)
                }
            } label: {
                Image(systemName: viewModel.isFavorite(item) ? "star.fill" : "star")
                    .font(.title3)
                    .foregroundStyle(viewModel.isFavorite(item) ? Color.yellow : Color.secondary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Text(viewModel.displayLine(for: item))
                .font(.headline)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    List {
        MediaRowView(
            item: MediaItem(
                title: "Sample",
                link: "sample",
                category: .albums,
                releaseDate: Date(),
                source: "Bandcamp",
                artistName: "Sample Artist",
                location: nil,
                format: .vinyl,
                streamingService: nil,
                gameSystem: nil,
                episodeNumber: nil
            )
        )
    }
    .environmentObject(MediaLibraryViewModel())
}
