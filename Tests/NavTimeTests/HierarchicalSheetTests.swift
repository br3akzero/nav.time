import Testing
import SwiftUI
@testable import NavTime

@Suite("Hierarchical Sheet Presentation")
@MainActor
struct HierarchicalSheetTests {

    @Test("second sheet call appends child sheet to stack")
    func secondSheetCallAppendsChild() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        router.sheet(.settings)
        #expect(router.sheetStack.count == 2)
        #expect(router.sheetRoute == .settings)
    }

    @Test("third sheet call builds three-deep hierarchy")
    func thirdSheetCallBuildsThreeDeepHierarchy() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        router.sheet(.settings)
        router.sheet(.profile)
        #expect(router.sheetStack.count == 3)
        #expect(router.sheetRoute == .profile)
    }

    @Test("dismissSheet on child sheet returns to parent")
    func dismissSheetOnChildReturnsToParent() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        router.sheet(.settings)
        router.dismissSheet()
        #expect(router.sheetStack.count == 1)
        #expect(router.sheetRoute == .detail)
    }

    @Test("dismissSheet on child calls only child onDismiss")
    func dismissSheetOnChildCallsOnlyChildDismiss() {
        let router = Router<TestRoute>(root: .home)
        var parentDismissed = false
        var childDismissed = false
        router.sheet(.detail, onDismiss: { parentDismissed = true })
        router.sheet(.settings, onDismiss: { childDismissed = true })
        router.dismissSheet()
        #expect(childDismissed)
        #expect(!parentDismissed)
    }

    @Test("sheetPresentationDetents reflects topmost sheet")
    func detentsReflectsTopmostSheet() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail, detents: [.large])
        router.sheet(.settings, detents: [.medium])
        #expect(router.sheetPresentationDetents == [.medium])
    }

    @Test("after dismissing child sheet, detents revert to parent sheet")
    func afterDismissingChildDetentsRevertToParent() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail, detents: [.large])
        router.sheet(.settings, detents: [.medium])
        router.dismissSheet()
        #expect(router.sheetPresentationDetents == [.large])
    }
}
