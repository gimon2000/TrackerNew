//
//  CreateTrackerPresenterProtocol.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import Foundation

protocol CreateTrackerPresenterProtocol {
    var createTrackerView: CreateTrackerViewControllerProtocol? { get set }
    
    func createTracker(name: String) 
    func setWeekdaysChecked(weekdaysChecked:[Weekdays])
    func isWeekdaysCheckedNil() -> Bool
}
