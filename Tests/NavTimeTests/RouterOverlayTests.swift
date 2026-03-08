import Testing
import SwiftUI
@testable import NavTime

@Suite("Router Universal Overlay")
@MainActor
struct RouterOverlayTests {

    @Test("universalOverlay sets universalOverlayRoute")
    func universalOverlaySetsRoute() {
        let router = Router<TestRoute>(root: .home)
        router.universalOverlay(.modal, animation: nil)
        #expect(router.universalOverlayRoute == .modal)
    }

    @Test("hasUniversalOverlay is true after presenting")
    func hasUniversalOverlayIsTrueAfterPresenting() {
        let router = Router<TestRoute>(root: .home)
        router.universalOverlay(.modal, animation: nil)
        #expect(router.hasUniversalOverlay)
    }

    @Test("hasUniversalOverlay is false initially")
    func hasUniversalOverlayIsFalseInitially() {
        let router = Router<TestRoute>(root: .home)
        #expect(!router.hasUniversalOverlay)
    }

    @Test("dismissUniversalOverlay nils the route")
    func dismissUniversalOverlayNilsRoute() {
        let router = Router<TestRoute>(root: .home)
        router.universalOverlay(.modal, animation: nil)
        router.dismissUniversalOverlay(animation: nil)
        #expect(router.universalOverlayRoute == nil)
    }

    @Test("hasUniversalOverlay is false after dismissing")
    func hasUniversalOverlayIsFalseAfterDismissing() {
        let router = Router<TestRoute>(root: .home)
        router.universalOverlay(.modal, animation: nil)
        router.dismissUniversalOverlay(animation: nil)
        #expect(!router.hasUniversalOverlay)
    }

    @Test("dismissUniversalOverlay on nil route is a no-op")
    func dismissUniversalOverlayOnNilRouteIsNoOp() {
        let router = Router<TestRoute>(root: .home)
        router.dismissUniversalOverlay(animation: nil)
        #expect(router.universalOverlayRoute == nil)
    }

    @Test("onOverlayPresenting callback fires when presenting overlay")
    func onOverlayPresentingCallbackFires() {
        let router = Router<TestRoute>(root: .home)
        var callbackFired = false
        router.onOverlayPresenting = { callbackFired = true }
        router.universalOverlay(.modal, animation: nil)
        #expect(callbackFired)
    }

    @Test("universalOverlay does not affect navigation stack")
    func universalOverlayDoesNotAffectStack() {
        let router = Router<TestRoute>(root: .home)
        router.push(.detail)
        router.universalOverlay(.modal, animation: nil)
        #expect(router.routes == [.detail])
    }
}
