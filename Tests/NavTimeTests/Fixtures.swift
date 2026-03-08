import Testing
import SwiftUI
@testable import NavTime

// MARK: - Shared Test Fixtures

@MainActor
enum TestRoute: String, @preconcurrency Routable {
    case home, detail, settings, profile, modal

    var id: String { rawValue }
    var description: String { rawValue }
    var body: some View { EmptyView() }
}

@MainActor
enum TestTab: String, @preconcurrency TabRoutable {
    case first, second, third

    typealias RouteType = TestRoute

    var rootRoute: TestRoute {
        switch self {
        case .first: return .home
        case .second: return .detail
        case .third: return .settings
        }
    }

    var title: String { rawValue }
    var icon: String { "circle" }
    var id: String { rawValue }
    var description: String { rawValue }
}
