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

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    List {
        MediaRowView(item: MediaItem(title: "Sample", subtitle: "Detail", link: "sample"))
    }
    .environmentObject(MediaLibraryViewModel())
}
