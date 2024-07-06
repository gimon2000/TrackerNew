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
    let schedule: [Weekdays]?
    let eventDate: Date?
}
