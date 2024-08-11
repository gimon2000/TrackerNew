//
//  Weekdays.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import Foundation

enum Weekdays: Int, CaseIterable, Codable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var fullName: String {
        switch self {
        case .monday:
            return NSLocalizedString(
                "monday.fullName",
                comment: "Text displayed in table"
            )
        case .tuesday:
            return NSLocalizedString(
                "tuesday.fullName",
                comment: "Text displayed in table"
            )
        case .wednesday:
            return NSLocalizedString(
                "wednesday.fullName",
                comment: "Text displayed in table"
            )
        case .thursday:
            return NSLocalizedString(
                "thursday.fullName",
                comment: "Text displayed in table"
            )
        case .friday:
            return NSLocalizedString(
                "friday.fullName",
                comment: "Text displayed in table"
            )
        case .saturday:
            return NSLocalizedString(
                "saturday.fullName",
                comment: "Text displayed in table"
            )
        case .sunday:
            return NSLocalizedString(
                "sunday.fullName",
                comment: "Text displayed in table"
            )
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return NSLocalizedString(
                "monday.shortName",
                comment: "Text displayed in table"
            )
        case .tuesday:
            return NSLocalizedString(
                "tuesday.shortName",
                comment: "Text displayed in table"
            )
        case .wednesday:
            return NSLocalizedString(
                "wednesday.shortName",
                comment: "Text displayed in table"
            )
        case .thursday:
            return NSLocalizedString(
                "thursday.shortName",
                comment: "Text displayed in table"
            )
        case .friday:
            return NSLocalizedString(
                "friday.shortName",
                comment: "Text displayed in table"
            )
        case .saturday:
            return NSLocalizedString(
                "saturday.shortName",
                comment: "Text displayed in table"
            )
        case .sunday:
            return NSLocalizedString(
                "sunday.shortName",
                comment: "Text displayed in table"
            )
        }
    }
}
