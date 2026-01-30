import SwiftUI

@main
struct MagicMediaManagerApp: App {
    @StateObject private var viewModel = LibraryViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(viewModel)
                .tint(.pink)
                .preferredColorScheme(.dark)
        }
    }
}
