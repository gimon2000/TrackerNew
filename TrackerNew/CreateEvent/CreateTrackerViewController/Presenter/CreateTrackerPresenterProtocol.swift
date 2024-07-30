//
//  CreateTrackerPresenterProtocol.swift
//  TrackerNew
//
//  Created by gimon on 29.06.2024.
//

import UIKit

protocol CreateTrackerPresenterProtocol {
    var createTrackerView: CreateTrackerViewControllerProtocol? { get set }
    var arrayEmojis: [String] { get }
    var arrayColors: [UIColor] { get }
    
    func createTracker(name: String)
    func setWeekdaysChecked(weekdaysChecked:[Weekdays])
    func isWeekdaysCheckedNil() -> Bool
    func getSubtitle() -> String
    func containWeekday(weekday: Weekdays) -> Bool
    func setSelectedEmoji(index: Int)
    func setSelectedColor(index: Int)
    func selectedEmojiIsEmpty() -> Bool
    func selectedColorIsEmpty() -> Bool
}
