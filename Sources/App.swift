import SwiftUI

@main
struct ClipboardHistoryApp: App {
    @StateObject private var store = ClipboardStore()

    var body: some Scene {
        MenuBarExtra("历史粘贴", systemImage: "list.clipboard") {
            ContentView()
                .environmentObject(store)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environmentObject(store)
        }
    }
}
