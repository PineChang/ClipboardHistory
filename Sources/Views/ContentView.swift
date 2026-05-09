import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: ClipboardStore

    var body: some View {
        VStack(spacing: 0) {
            Text("历史粘贴")
                .font(.headline)
                .padding()
            Divider()
            if store.sortedItems.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    Text("还没有复制记录")
                        .font(.body)
                        .foregroundColor(.secondary)
                    Text("试试复制一段文字或图片吧")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                List(store.sortedItems) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            if item.isPinned {
                                Image(systemName: "pin.fill")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            Text(item.type == .text ? item.content : "[图片]")
                                .lineLimit(2)
                                .font(.system(size: 13))
                            Spacer()
                        }
                        Text(item.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .frame(width: 340, height: 520)
    }
}
