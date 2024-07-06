//
//  ScheduleViewControllerDelegate.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func setWeekdaysChecked(_:[Weekdays])
    func containWeekday(weekday: Weekdays) -> Bool
}
