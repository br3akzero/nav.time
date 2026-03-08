import Testing
import SwiftUI
@testable import NavTime

@Suite("Router Sheet Presentation")
@MainActor
struct RouterSheetTests {

    @Test("sheet sets sheetRoute")
    func sheetSetsSheetRoute() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        #expect(router.sheetRoute == .detail)
    }

    @Test("sheet creates single item in sheetStack")
    func sheetCreatesSingleItemInStack() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        #expect(router.sheetStack.count == 1)
    }

    @Test("sheet stores detents in sheetStack")
    func sheetStoresDetents() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail, detents: [.medium, .large])
        #expect(router.sheetPresentationDetents == [.medium, .large])
    }

    @Test("sheet stores drag indicator visibility")
    func sheetStoresDragIndicator() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail, dragIndicator: .visible)
        #expect(router.sheetPresentationDragIndicator == .visible)
    }

    @Test("dismissSheet removes sheet from stack")
    func dismissSheetRemovesFromStack() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        router.dismissSheet()
        #expect(router.sheetStack.isEmpty)
        #expect(router.sheetRoute == nil)
    }

    @Test("dismissSheet calls onDismiss handler")
    func dismissSheetCallsOnDismiss() {
        let router = Router<TestRoute>(root: .home)
        var handlerCalled = false
        router.sheet(.detail, onDismiss: { handlerCalled = true })
        router.dismissSheet()
        #expect(handlerCalled)
    }

    @Test("dismissSheet on empty stack is a no-op")
    func dismissSheetOnEmptyStackIsNoOp() {
        let router = Router<TestRoute>(root: .home)
        router.dismissSheet()
        #expect(router.sheetStack.isEmpty)
    }

    @Test("dismissAllSheets clears entire stack")
    func dismissAllSheetsClearsStack() {
        let router = Router<TestRoute>(root: .home)
        router.sheet(.detail)
        router.sheet(.settings)
        router.sheet(.profile)
        router.dismissAllSheets()
        #expect(router.sheetStack.isEmpty)
    }

    @Test("dismissAllSheets calls all onDismiss handlers")
    func dismissAllSheetsCallsAllHandlers() {
        let router = Router<TestRoute>(root: .home)
        var callCount = 0
        router.sheet(.detail, onDismiss: { callCount += 1 })
        router.sheet(.settings, onDismiss: { callCount += 1 })
        router.sheet(.profile, onDismiss: { callCount += 1 })
        router.dismissAllSheets()
        #expect(callCount == 3)
    }

    @Test("dismissAllSheets calls handlers in reverse order")
    func dismissAllSheetsCallsHandlersInReverseOrder() {
        let router = Router<TestRoute>(root: .home)
        var order: [String] = []
        router.sheet(.detail, onDismiss: { order.append("detail") })
        router.sheet(.settings, onDismiss: { order.append("settings") })
        router.sheet(.profile, onDismiss: { order.append("profile") })
        router.dismissAllSheets()
        #expect(order == ["profile", "settings", "detail"])
    }

    @Test("dismissAllSheets on empty stack is a no-op")
    func dismissAllSheetsOnEmptyStackIsNoOp() {
        let router = Router<TestRoute>(root: .home)
        router.dismissAllSheets()
        #expect(router.sheetStack.isEmpty)
    }
}
