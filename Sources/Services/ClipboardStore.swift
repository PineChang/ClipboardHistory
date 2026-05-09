import Foundation
import SwiftUI
import AppKit

class ClipboardStore: ObservableObject {
    @Published var items: [ClipboardItem] = []

    @AppStorage("storageDays") var storageDays: Int = 3

    static var imageDirectory: URL {
        FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask
        ).first!
        .appendingPathComponent("ClipboardHistory")
        .appendingPathComponent("images")
    }

    private let maxItems = 500
    private let baseURL: URL
    private let itemsURL: URL
    private let imagesURL: URL

    init() {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask
        ).first!
        baseURL = appSupport.appendingPathComponent("ClipboardHistory")
        itemsURL = baseURL.appendingPathComponent("items.json")
        imagesURL = baseURL.appendingPathComponent("images")

        createDirectories()
        load()
        cleanExpired()
    }

    // MARK: - Computed

    var sortedItems: [ClipboardItem] {
        items.sorted { a, b in
            if a.isPinned != b.isPinned { return a.isPinned }
            return a.timestamp > b.timestamp
        }
    }

    // MARK: - Add

    func addText(_ content: String) {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if let last = items.first, last.type == .text, last.content == trimmed { return }

        let item = ClipboardItem(
            id: UUID(), type: .text, content: trimmed,
            imageFileName: nil, timestamp: Date(), isPinned: false
        )
        insertAndSave(item)
    }

    func addImage(_ data: Data) {
        let id = UUID()
        let fileName = "\(id.uuidString).png"
        let fileURL = imagesURL.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
        } catch {
            print("Failed to save image: \(error)")
            return
        }

        let item = ClipboardItem(
            id: id, type: .image, content: "",
            imageFileName: fileName, timestamp: Date(), isPinned: false
        )
        insertAndSave(item)
    }

    // MARK: - Delete

    func delete(_ id: UUID) {
        if let item = items.first(where: { $0.id == id }), item.type == .image,
           let fileName = item.imageFileName {
            try? FileManager.default.removeItem(at: imagesURL.appendingPathComponent(fileName))
        }
        items.removeAll { $0.id == id }
        save()
    }

    // MARK: - Pin

    func togglePin(_ id: UUID) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].isPinned.toggle()
            save()
        }
    }

    // MARK: - Cleanup

    func cleanExpired() {
        let cutoff = Calendar.current.date(
            byAdding: .day, value: -storageDays, to: Date()
        ) ?? Date()
        let expired = items.filter { !$0.isPinned && $0.timestamp < cutoff }
        for item in expired {
            if item.type == .image, let fileName = item.imageFileName {
                try? FileManager.default.removeItem(at: imagesURL.appendingPathComponent(fileName))
            }
        }
        items.removeAll { !$0.isPinned && $0.timestamp < cutoff }
        save()
    }

    // MARK: - Persistence

    private func insertAndSave(_ item: ClipboardItem) {
        items.insert(item, at: 0)
        if items.count > maxItems {
            let overflow = items.suffix(from: maxItems)
            for old in overflow where old.type == .image {
                if let name = old.imageFileName {
                    try? FileManager.default.removeItem(at: imagesURL.appendingPathComponent(name))
                }
            }
            items = Array(items.prefix(maxItems))
        }
        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: itemsURL, options: .atomic)
        } catch {
            print("Failed to save items: \(error)")
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: itemsURL.path) else { return }
        do {
            let data = try Data(contentsOf: itemsURL)
            items = try JSONDecoder().decode([ClipboardItem].self, from: data)
        } catch {
            print("Failed to load items: \(error)")
        }
    }

    private func createDirectories() {
        try? FileManager.default.createDirectory(at: baseURL, withIntermediateDirectories: true)
        try? FileManager.default.createDirectory(at: imagesURL, withIntermediateDirectories: true)
    }
}
