import Foundation

enum ItemType: String, Codable {
    case text
    case image
}

struct ClipboardItem: Identifiable, Codable, Equatable {
    let id: UUID
    let type: ItemType
    let content: String
    let imageFileName: String?
    let timestamp: Date
    var isPinned: Bool
}
