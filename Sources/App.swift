import SwiftUI
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    let store = ClipboardStore()
    private var monitor: ClipboardMonitor?

    override init() {
        super.init()
        monitor = ClipboardMonitor(store: store)
        monitor?.start()
    }
}

@main
struct ClipboardHistoryApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("历史粘贴", systemImage: "list.clipboard") {
            ContentView()
                .environmentObject(appDelegate.store)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environmentObject(appDelegate.store)
        }
    }
}
