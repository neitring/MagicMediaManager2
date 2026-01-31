import SwiftUI

@main
struct MagicMediaManagerApp: App {
    @StateObject private var viewModel = MediaLibraryViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .tint(.pink)
                .preferredColorScheme(.dark)
        }
    }
}
