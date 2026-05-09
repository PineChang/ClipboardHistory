import AppKit

final class ClipboardMonitor {
    private let store: ClipboardStore
    private var timer: Timer?
    private var lastChangeCount: Int = 0

    init(store: ClipboardStore) {
        self.store = store
    }

    func start() {
        lastChangeCount = NSPasteboard.general.changeCount
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkPasteboard()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func checkPasteboard() {
        let pb = NSPasteboard.general
        let currentChangeCount = pb.changeCount

        guard currentChangeCount != lastChangeCount else { return }
        lastChangeCount = currentChangeCount

        if let text = pb.string(forType: .string)?.trimmingCharacters(in: .whitespacesAndNewlines),
           !text.isEmpty {
            store.addText(text)
            return
        }

        if let imageData = pb.data(forType: .png) ?? pb.data(forType: .tiff) {
            store.addImage(imageData)
        }
    }
}
