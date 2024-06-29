//
//  CreateTrackerPresenter.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import Foundation

final class CreateTrackerPresenter: CreateTrackerPresenterProtocol {
    
    // MARK: - Public Properties
    weak var createTrackerView: CreateTrackerViewControllerProtocol?
    
    var weekdaysChecked:[Weekdays] = []
    var category: String = "Тест"
}
