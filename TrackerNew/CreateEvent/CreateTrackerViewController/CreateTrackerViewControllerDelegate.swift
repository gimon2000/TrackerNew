//
//  CreateTrackerViewControllerDelegate.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import Foundation

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func setWeekdaysChecked(_ weekdaysCheckedArray: [Weekdays])
}
