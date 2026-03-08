import Testing
import SwiftUI
@testable import NavTime

@Suite("Router Full Screen Cover")
@MainActor
struct RouterFullScreenCoverTests {

    @Test("fullScreenCover sets fullScreenCoverRoute")
    func fullScreenCoverSetsRoute() {
        let router = Router<TestRoute>(root: .home)
        router.fullScreenCover(.modal)
        #expect(router.fullScreenCoverRoute == .modal)
    }

    @Test("dismissFullScreenCover nils the route")
    func dismissFullScreenCoverNilsRoute() {
        let router = Router<TestRoute>(root: .home)
        router.fullScreenCover(.modal)
        router.dismissFullScreenCover()
        #expect(router.fullScreenCoverRoute == nil)
    }

    @Test("dismissFullScreenCover calls onDismiss handler")
    func dismissFullScreenCoverCallsHandler() {
        let router = Router<TestRoute>(root: .home)
        var handlerCalled = false
        router.fullScreenCover(.modal, onDismiss: { handlerCalled = true })
        router.dismissFullScreenCover()
        #expect(handlerCalled)
    }

    @Test("dismissFullScreenCover on nil route is a no-op")
    func dismissFullScreenCoverOnNilRouteIsNoOp() {
        let router = Router<TestRoute>(root: .home)
        router.dismissFullScreenCover()
        #expect(router.fullScreenCoverRoute == nil)
    }

    @Test("fullScreenCover does not affect navigation stack")
    func fullScreenCoverDoesNotAffectStack() {
        let router = Router<TestRoute>(root: .home)
        router.push(.detail)
        router.fullScreenCover(.modal)
        #expect(router.routes == [.detail])
    }
}
