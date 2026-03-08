import Testing
import SwiftUI
@testable import NavTime

@Suite("TabRouter Universal Overlay")
@MainActor
struct TabRouterOverlayTests {

    @Test("universalOverlay sets universalOverlayRoute")
    func universalOverlaySetsRoute() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.universalOverlay(.modal, animation: nil)
        #expect(tabRouter.universalOverlayRoute == .modal)
    }

    @Test("hasUniversalOverlay is true after presenting")
    func hasUniversalOverlayIsTrueAfterPresenting() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.universalOverlay(.modal, animation: nil)
        #expect(tabRouter.hasUniversalOverlay)
    }

    @Test("hasUniversalOverlay is false initially")
    func hasUniversalOverlayIsFalseInitially() {
        let tabRouter = TabRouter<TestTab>()
        #expect(!tabRouter.hasUniversalOverlay)
    }

    @Test("dismissUniversalOverlay nils the route")
    func dismissUniversalOverlayNilsRoute() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.universalOverlay(.modal, animation: nil)
        tabRouter.dismissUniversalOverlay(animation: nil)
        #expect(tabRouter.universalOverlayRoute == nil)
    }

    @Test("dismissUniversalOverlay on nil route is a no-op")
    func dismissUniversalOverlayOnNilIsNoOp() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.dismissUniversalOverlay(animation: nil)
        #expect(tabRouter.universalOverlayRoute == nil)
    }

    @Test("TabRouter universalOverlay dismisses all router-level overlays")
    func tabRouterOverlayDismissesRouterOverlays() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.router(for: .first).universalOverlay(.modal, animation: nil)
        tabRouter.router(for: .second).universalOverlay(.modal, animation: nil)
        // Presenting TabRouter-level overlay should clear all router overlays
        tabRouter.universalOverlay(.profile, animation: nil)
        #expect(!tabRouter.router(for: .first).hasUniversalOverlay)
        #expect(!tabRouter.router(for: .second).hasUniversalOverlay)
        #expect(tabRouter.hasUniversalOverlay)
    }

    @Test("presenting router overlay triggers TabRouter dismissal via onOverlayPresenting")
    func routerOverlayDismissesTabRouterOverlay() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.universalOverlay(.modal, animation: nil)
        #expect(tabRouter.hasUniversalOverlay)
        // Presenting a router-level overlay fires onOverlayPresenting, dismissing the TabRouter overlay
        tabRouter.router(for: .first).universalOverlay(.detail, animation: nil)
        #expect(!tabRouter.hasUniversalOverlay)
    }

    @Test("TabRouter universalOverlay persists across tab switches")
    func universalOverlayPersistsAcrossTabSwitches() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.universalOverlay(.modal, animation: nil)
        tabRouter.switchTab(to: .second)
        #expect(tabRouter.universalOverlayRoute == .modal)
        tabRouter.switchTab(to: .third)
        #expect(tabRouter.universalOverlayRoute == .modal)
    }
}
