//
//  CreateTrackerPresenterProtocol.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import Foundation

protocol CreateTrackerPresenterProtocol {
    var createTrackerView: CreateTrackerViewControllerProtocol? { get set }
    var weekdaysChecked:[Weekdays] { get set }
    var category: String { get }
}
