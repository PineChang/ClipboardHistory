import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: ClipboardStore

    var body: some View {
        TabView {
            Text("存储天数设置")
                .tabItem { Label("存储", systemImage: "clock") }
            Text("开机启动设置")
                .tabItem { Label("启动", systemImage: "power") }
        }
        .frame(width: 400, height: 300)
    }
}
