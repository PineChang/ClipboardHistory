import SwiftUI

struct ClipboardCard: View {
    let item: ClipboardItem
    let onTap: () -> Void
    let onTogglePin: () -> Void
    let onDelete: () -> Void

    @State private var isHovered = false
    @State private var showDeleteConfirm = false

    var body: some View {
        HStack(spacing: 0) {
            if item.isPinned {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.36, green: 0.61, blue: 0.84))
                    .frame(width: 3)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    contentArea
                    Spacer(minLength: 8)
                    timestampView
                }
                bottomBar
            }
            .padding(.leading, item.isPinned ? 9 : 12)
            .padding(.trailing, 12)
            .padding(.vertical, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isHovered
                    ? Color(red: 0.91, green: 0.95, blue: 0.98)
                    : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.91, green: 0.93, blue: 0.95), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isHovered)
        .onHover { isHovered = $0 }
        .onTapGesture { onTap() }
        .contextMenu {
            Button(item.isPinned ? "取消置顶" : "置顶") { onTogglePin() }
            Divider()
            Button("删除") { showDeleteConfirm = true }
        }
        .alert("确认删除", isPresented: $showDeleteConfirm) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) { onDelete() }
        } message: {
            Text("删除后无法恢复。")
        }
    }

    @ViewBuilder
    private var contentArea: some View {
        if item.type == .image, let fileName = item.imageFileName {
            imageThumbnail(fileName: fileName)
        } else {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.84))
                    Text("文字")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(red: 0.36, green: 0.61, blue: 0.84))
                }
                Text(item.content)
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.10, green: 0.10, blue: 0.18))
                    .lineLimit(2)
            }
        }
    }

    private func imageThumbnail(fileName: String) -> some View {
        let url = ClipboardStore.imageDirectory.appendingPathComponent(fileName)
        return Group {
            if let imageData = try? Data(contentsOf: url),
               let nsImage = NSImage(data: imageData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.93, green: 0.94, blue: 0.96))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    )
            }
        }
    }

    private var timestampView: some View {
        Text(item.timestamp, style: .relative)
            .font(.system(size: 11))
            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.60))
    }

    private var bottomBar: some View {
        HStack(spacing: 12) {
            Spacer()
            pinButton
            deleteButton
        }
    }

    private var pinButton: some View {
        Button(action: onTogglePin) {
            Image(systemName: item.isPinned ? "pin.slash.fill" : "pin.fill")
                .font(.system(size: 11))
                .foregroundColor(item.isPinned
                    ? Color(red: 0.36, green: 0.61, blue: 0.84)
                    : Color(red: 0.78, green: 0.78, blue: 0.80))
        }
        .buttonStyle(.plain)
    }

    private var deleteButton: some View {
        Button(action: { showDeleteConfirm = true }) {
            Image(systemName: "trash")
                .font(.system(size: 11))
                .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.80))
        }
        .buttonStyle(.plain)
    }
}
