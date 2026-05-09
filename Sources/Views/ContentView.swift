import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: ClipboardStore

    var body: some View {
        VStack(spacing: 0) {
            headerView
            Divider()
                .overlay(Color(red: 0.91, green: 0.93, blue: 0.95))
            cardListArea
            Divider()
                .overlay(Color(red: 0.91, green: 0.93, blue: 0.95))
            bottomBar
        }
        .frame(width: 340, height: 520)
        .background(Color(red: 0.94, green: 0.96, blue: 0.98))
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Image(systemName: "list.clipboard")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.84))
            Text("历史粘贴")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.18))
            Spacer()
            Text("\(store.sortedItems.count) 条")
                .font(.system(size: 11))
                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.60))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    // MARK: - Card List

    @ViewBuilder
    private var cardListArea: some View {
        if store.sortedItems.isEmpty {
            emptyState
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(store.sortedItems) { item in
                        ClipboardCard(
                            item: item,
                            onTap: { },
                            onTogglePin: { store.togglePin(item.id) },
                            onDelete: {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    store.delete(item.id)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 10) {
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 36))
                .foregroundColor(Color(red: 0.78, green: 0.82, blue: 0.88))
            Text("还没有复制记录")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.60))
            Text("试试复制一段文字或图片吧")
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.80))
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        HStack {
            Spacer()
            Button(action: {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.60))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
