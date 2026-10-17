import XCTest
@testable import Simplenote

// MARK: - Note+Extension Tests
//
class NoteLinkTests: XCTestCase {

    /// InMemory Storage!
    ///
    private let storage = MockupStorageManager()

    func testNoteInterlinkReferenceCount() {
        let (referencedNote, referencing) = insertSampleEntitiesWithInterlinkReferences()
        let noReference = referencing[0]
        let oneReference = referencing[1]
        let twoReference = referencing[2]
        let emptyContent = referencing[3]

        XCTAssertEqual(noReference.instancesOfReference(to: referencedNote), 0)
        XCTAssertEqual(oneReference.instancesOfReference(to: referencedNote), 1)
        XCTAssertEqual(twoReference.instancesOfReference(to: referencedNote), 2)
        XCTAssertEqual(emptyContent.instancesOfReference(to: referencedNote), 0)
    }

    /// Verifies that a note with a title yields a Markdown internal reference
    ///
    func testMarkdownInternalLinkContainsTitleAndPlainLink() {
        let note = storage.insertSampleNote(contents: "Some Title")
        note.createPreview()

        let link = note.markdownInternalLink

        XCTAssertEqual(link, "[Some Title](\(note.plainInternalLink!))")
    }

    /// Verifies that a just created note, which has no title preview yet, falls back to the plain internal link
    ///
    func testMarkdownInternalLinkFallsBackToPlainLinkWhenTitlePreviewIsMissing() {
        let note = storage.insertSampleNote(contents: "")

        XCTAssertNil(note.titlePreview)
        XCTAssertEqual(note.markdownInternalLink, note.plainInternalLink)
    }
}

// MARK: - Private
//
private extension NoteLinkTests {

    /// Inserts a collection of sample entities.
    ///
    func insertSampleEntitiesWithInterlinkReferences() -> (referenced: Note, samles: Array<Note>) {
        let referencedNote = storage.insertSampleNote(contents: "This note will be referenced to")
        var notesReferencing = Array<Note>()

        if let link = referencedNote.plainInternalLink {
            notesReferencing.append(storage.insertSampleNote(contents: "Does not contain reference"))
            notesReferencing.append(storage.insertSampleNote(contents: "This note contains one reference to note \(link)"))
            notesReferencing.append(storage.insertSampleNote(contents: "This note contains two reference \(link) to note \(link)"))
            notesReferencing.append(storage.insertSampleNote(contents: ""))
        }

        storage.save()

        return (referencedNote, notesReferencing)
    }
}
