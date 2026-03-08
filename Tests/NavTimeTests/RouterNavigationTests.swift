import Testing
import SwiftUI
@testable import NavTime

@Suite("Router Navigation Stack")
@MainActor
struct RouterNavigationTests {

    @Test("push adds route to stack")
    func pushAddsRoute() {
        let router = Router<TestRoute>(root: .home)
        router.push(.detail)
        #expect(router.routes == [.detail])
    }

    @Test("push multiple routes accumulates stack")
    func pushMultipleRoutes() {
        let router = Router<TestRoute>(root: .home)
        router.push(.detail)
        router.push(.settings)
        router.push(.profile)
        #expect(router.routes == [.detail, .settings, .profile])
    }

    @Test("pop removes last route")
    func popRemovesLastRoute() {
        let router = Router<TestRoute>(root: .home)
        router.push(.detail)
        router.push(.settings)
        router.pop()
        #expect(router.routes == [.detail])
    }

    @Test("pop on empty stack is a no-op")
    func popOnEmptyStackIsNoOp() {
        let router = Router<TestRoute>(root: .home)
        router.pop()
        #expect(router.routes.isEmpty)
    }

    @Test("popToRoot clears entire navigation stack")
    func popToRootClearsStack() {
        let router = Router<TestRoute>(root: .home)
        router.push(.detail)
        router.push(.settings)
        router.push(.profile)
        router.popToRoot()
        #expect(router.routes.isEmpty)
    }

    @Test("popToRoot on empty stack is a no-op")
    func popToRootOnEmptyStackIsNoOp() {
        let router = Router<TestRoute>(root: .home)
        router.popToRoot()
        #expect(router.routes.isEmpty)
    }

    @Test("switchRoot updates rootRoute")
    func switchRootUpdatesRootRoute() {
        let router = Router<TestRoute>(root: .home)
        router.switchRoot(.settings)
        #expect(router.rootRoute == .settings)
    }

    @Test("switchRoot clears navigation stack")
    func switchRootClearsStack() {
        let router = Router<TestRoute>(root: .home)
        router.push(.detail)
        router.push(.settings)
        router.switchRoot(.profile)
        #expect(router.routes.isEmpty)
    }

    @Test("switchRoot updates root and clears stack together")
    func switchRootUpdatesBoth() {
        let router = Router<TestRoute>(root: .home)
        router.push(.detail)
        router.switchRoot(.settings)
        #expect(router.rootRoute == .settings)
        #expect(router.routes.isEmpty)
    }

    @Test("initial routes array is empty")
    func initialRoutesIsEmpty() {
        let router = Router<TestRoute>(root: .home)
        #expect(router.routes.isEmpty)
    }

    @Test("initial rootRoute matches init parameter")
    func initialRootRouteMatchesInit() {
        let router = Router<TestRoute>(root: .profile)
        #expect(router.rootRoute == .profile)
    }
}
