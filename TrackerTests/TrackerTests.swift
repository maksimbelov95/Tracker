
import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testLightThemeTrackerVC() throws {
        let vc = TrackerViewController()
        assertSnapshot(
            matching: vc,
            as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testDarkThemeDarkTrackerVC() throws {
        let vc = TrackerViewController()
        assertSnapshot(
            matching: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}

