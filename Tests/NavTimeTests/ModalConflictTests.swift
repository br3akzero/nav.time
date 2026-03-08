import Testing
import SwiftUI
@testable import NavTime

@Suite("Modal Conflict Resolution")
@MainActor
struct ModalConflictTests {

    @Test("presenting sheet while fullScreenCover active dismisses cover immediately")
    func presentingSheetDismissesCoverImmediately() {
        let router = Router<TestRoute>(root: .home)
        router.fullScreenCover(.modal)
        #expect(router.fullScreenCoverRoute == .modal)
        router.sheet(.detail)
        // The cover is nil'd immediately before the async delay
        #expect(router.fullScreenCoverRoute == nil)
    }

    @Test("presenting sheet while fullScreenCover active calls cover's onDismiss")
    func presentingSheetCallsCoverOnDismiss() {
        let router = Router<TestRoute>(root: .home)
        var coverDismissed = false
        router.fullScreenCover(.modal, onDismiss: { coverDismissed = true })
        router.sheet(.detail)
        #expect(coverDismissed)
    }

    @Test("presenting fullScreenCover while sheet active dismisses sheet stack immediately")
    func presentingCoverDismissesSheetImmediately() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        router.fullScreenCover(.modal)
        #expect(router.sheetStack.isEmpty)
    }

    @Test("presenting fullScreenCover while sheet active calls all sheet onDismiss handlers")
    func presentingCoverCallsSheetDismissHandlers() {
        let router = Router<TestRoute>(root: .home)
        var callCount = 0
        router.sheet(.detail, onDismiss: { callCount += 1 })
        router.sheet(.settings, onDismiss: { callCount += 1 })
        router.fullScreenCover(.modal)
        #expect(callCount == 2)
    }

    @Test("sheet is deferred after fullScreenCover conflict resolution")
    func sheetIsDeferredAfterCoverConflict() async {
        let router = Router<TestRoute>(root: .home)
        router.fullScreenCover(.modal)
        router.sheet(.detail)
        // Before the 350ms delay, sheet is not yet presented
        #expect(router.sheetStack.isEmpty)
        // After 350ms delay, sheet should be presented
        try? await Task.sleep(for: .milliseconds(400))
        #expect(router.sheetRoute == .detail)
    }

    @Test("fullScreenCover is deferred after sheet conflict resolution")
    func coverIsDeferredAfterSheetConflict() async {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        router.fullScreenCover(.modal)
        // Before the 350ms delay, cover is not yet presented
        #expect(router.fullScreenCoverRoute == nil)
        // After 350ms delay, cover should be presented
        try? await Task.sleep(for: .milliseconds(400))
        #expect(router.fullScreenCoverRoute == .modal)
    }
}
