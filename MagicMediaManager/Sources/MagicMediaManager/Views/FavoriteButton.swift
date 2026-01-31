import SwiftUI

struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        } label: {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundStyle(isFavorite ? Color.yellow : Color.secondary)
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 44, height: 44, alignment: .center)
                .contentShape(Rectangle())
                .accessibilityLabel(isFavorite ? "Remove favorite" : "Add favorite")
        }
        .buttonStyle(.plain)
    }
}
