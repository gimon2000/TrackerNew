//
//  SnapshotTrackerTests.swift
//  SnapshotTrackerTests
//
//  Created by gimon on 18.08.2024.
//

import XCTest
import SnapshotTesting
@testable import TrackerNew

final class SnapshotTrackerTests: XCTestCase {
    
    func testTrackerViewController() throws {
        let vc = TrackersViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
}
