import Testing
import SwiftUI
@testable import NavTime

@Suite("TabRouter")
@MainActor
struct TabRouterTests {

    @Test("default selected tab is first allCases element")
    func defaultSelectedTabIsFirst() {
        let tabRouter = TabRouter<TestTab>()
        #expect(tabRouter.selectedTab == TestTab.allCases.first)
    }

    @Test("init with selectedTab sets correct tab")
    func initWithSelectedTabSetsCorrectTab() {
        let tabRouter = TabRouter<TestTab>(selectedTab: .second)
        #expect(tabRouter.selectedTab == .second)
    }

    @Test("switchTab changes selectedTab")
    func switchTabChangesSelectedTab() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.switchTab(to: .second)
        #expect(tabRouter.selectedTab == .second)
    }

    @Test("switchTab to same tab is a no-op")
    func switchTabToSameTabIsNoOp() {
        let tabRouter = TabRouter<TestTab>(selectedTab: .first)
        tabRouter.switchTab(to: .first)
        #expect(tabRouter.selectedTab == .first)
    }

    @Test("router(for:) returns router with correct root route")
    func routerForTabHasCorrectRootRoute() {
        let tabRouter = TabRouter<TestTab>()
        let router = tabRouter.router(for: .second)
        #expect(router.rootRoute == TestTab.second.rootRoute)
    }

    @Test("router(for:) returns same instance on repeated calls")
    func routerForTabReturnsSameInstance() {
        let tabRouter = TabRouter<TestTab>()
        let router1 = tabRouter.router(for: .first)
        let router2 = tabRouter.router(for: .first)
        #expect(router1 === router2)
    }

    @Test("currentRouter returns router for selected tab")
    func currentRouterReturnsRouterForSelectedTab() {
        let tabRouter = TabRouter<TestTab>(selectedTab: .second)
        let current = tabRouter.currentRouter
        let explicit = tabRouter.router(for: .second)
        #expect(current === explicit)
    }

    @Test("each tab has an independent navigation stack")
    func eachTabHasIndependentNavigationStack() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.router(for: .first).push(.detail)
        tabRouter.router(for: .first).push(.settings)
        #expect(tabRouter.router(for: .second).routes.isEmpty)
        #expect(tabRouter.router(for: .third).routes.isEmpty)
    }

    @Test("pushing on one tab does not affect another tab")
    func pushingOnOneTabDoesNotAffectAnother() {
        let tabRouter = TabRouter<TestTab>()
        tabRouter.router(for: .first).push(.detail)
        #expect(tabRouter.router(for: .first).routes == [.detail])
        #expect(tabRouter.router(for: .second).routes.isEmpty)
    }

    @Test("routers are initialized for all tabs")
    func routersAreInitializedForAllTabs() {
        let tabRouter = TabRouter<TestTab>()
        for tab in TestTab.allCases {
            #expect(tabRouter.routers[tab] != nil)
        }
    }
}
