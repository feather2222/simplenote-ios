import Foundation

// MARK: - UIPasteboard + Interlink
//
extension UIPasteboard {

    /// Copies the Internal Link (Markdown Reference) into the OS Pasteboard
    ///
    @discardableResult
    func copyInternalLink(to note: Note) -> Bool {
        guard let link = note.markdownInternalLink else {
            return false
        }

        string = link
        return true
    }

    /// Copies the Public Link (if any) into the OS Pasteboard
    ///
    func copyPublicLink(to note: Note) {
        guard let link = note.publicLink else {
            return
        }

        string = link
    }
}
