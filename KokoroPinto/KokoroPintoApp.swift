import SwiftUI
import SwiftData

@main
struct KokoroPintoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: EmotionRecord.self)
    }
}
