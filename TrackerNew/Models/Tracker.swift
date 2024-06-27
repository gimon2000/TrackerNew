//
//  Tracker.swift
//  TrackerNew
//
//  Created by gimon on 27.06.2024.
//

import UIKit

struct Tracker {
    let id: UInt
    let name, emoji: String
    let color: UIColor
    let schedule: [Days]
}

enum Days {
    static let monday = "monday"
    static let tuesday = "tuesday"
    static let wednesday = "wednesday"
    static let thursday = "thursday"
    static let friday = "friday"
    static let saturday = "saturday"
    static let sunday = "sunday"
}
