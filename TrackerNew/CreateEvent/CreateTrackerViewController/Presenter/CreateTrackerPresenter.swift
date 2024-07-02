//
//  CreateTrackerPresenter.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import UIKit

final class CreateTrackerPresenter: CreateTrackerPresenterProtocol {
    
    // MARK: - Public Properties
    weak var createTrackerView: CreateTrackerViewControllerProtocol?
    
    // MARK: - Private Properties
    private var weekdaysChecked:[Weekdays] = []
    private let category: String = "Тест"
    private let emoji: String = "👍"
    private let color: UIColor = .red
    
    // MARK: - Public Methods
    func createTracker(name: String) {
        let tracker = Tracker(
            id: UInt.random(in: 0...UInt.max),
            name: name,
            emoji: emoji,
            color: color,
            schedule: weekdaysChecked
        )
        createTrackerView?.delegate?.setTracker(tracker: tracker)
    }
    
    func setWeekdaysChecked(weekdaysChecked:[Weekdays]) {
        self.weekdaysChecked = weekdaysChecked
    }
}
