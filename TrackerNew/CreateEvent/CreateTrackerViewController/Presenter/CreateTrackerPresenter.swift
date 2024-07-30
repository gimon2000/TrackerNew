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
    let arrayEmojis = [
        "🙂",
        "😻",
        "🌺",
        "🐶",
        "❤️",
        "😱",
        "😇",
        "😡",
        "🥶",
        "🤔",
        "🙌",
        "🍔",
        "🥦",
        "🏓",
        "🥇",
        "🎸",
        "🏝",
        "😪"
    ]
    let arrayColors: [UIColor] = [
        .ypColorFD4C49,
        .ypColorFF881E,
        .ypColor007BFA,
        .ypColor6E44FE,
        .ypColor33CF69,
        .ypColorE66DD4,
        .ypColorF9D4D4,
        .ypColor34A7FE,
        .ypColor46E69D,
        .ypColor35347C,
        .ypColorFF674D,
        .ypColorFF99CC,
        .ypColorF6C48B,
        .ypColor7994F5,
        .ypColor832CF1,
        .ypColorAD56DA,
        .ypColor8D72E6,
        .ypColor2FD058,
    ]
    
    // MARK: - Private Properties
    private var weekdaysChecked: [Weekdays]?
    private let category: String = "Тест"
    private var selectedEmoji: String = ""
    private var selectedColor: UIColor?
    private let color: UIColor = .red
    
    // MARK: - Public Methods
    func createTracker(name: String) {
        print(#fileID, #function, #line)
        if let weekdaysChecked = weekdaysChecked {
            let tracker = Tracker(
                id: UInt.random(in: 0...UInt(Int32.max)),
                name: name,
                emoji: selectedEmoji,
                color: selectedColor ?? .red,
                schedule: weekdaysChecked,
                eventDate: nil
            )
            createTrackerView?.delegate?.setTracker(tracker: tracker, category: category)
        } else {
            let tracker = Tracker(
                id: UInt.random(in: 0...UInt(Int32.max)),
                name: name,
                emoji: selectedEmoji,
                color: selectedColor ?? .red,
                schedule: nil,
                eventDate: Date()
            )
            createTrackerView?.delegate?.setTracker(tracker: tracker, category: category)
        }
        
    }
    
    func setWeekdaysChecked(weekdaysChecked:[Weekdays]) {
        self.weekdaysChecked = weekdaysChecked
        print(
            #fileID,
            #function,
            #line,
            "self.weekdaysChecked: \(String(describing: self.weekdaysChecked))"
        )
    }
    
    func containWeekday(weekday: Weekdays) -> Bool {
        print(#fileID, #function, #line)
        guard let weekdaysChecked else {
            print(#fileID, #function, #line)
            return false
        }
        return weekdaysChecked.contains(where: {$0 == weekday})
    }
    
    func isWeekdaysCheckedNil() -> Bool {
        print(#fileID, #function, #line)
        guard let weekdaysChecked else {
            print(#fileID, #function, #line)
            return true
        }
        return weekdaysChecked.isEmpty
    }
    
    func getSubtitle() -> String {
        print(#fileID, #function, #line)
        guard let weekdaysChecked else {
            print(#fileID, #function, #line)
            return ""
        }
        return weekdaysChecked.map{ $0.shortName }.joined(separator: ", ")
    }
    
    func setSelectedEmoji(index: Int) {
        print(#fileID, #function, #line)
        selectedEmoji = arrayEmojis[index]
    }
    
    func setSelectedColor(index: Int) {
        print(#fileID, #function, #line)
        selectedColor = arrayColors[index]
    }
    
    func selectedEmojiIsEmpty() -> Bool {
        print(#fileID, #function, #line)
        return !arrayEmojis.contains(selectedEmoji)
    }
    
    func selectedColorIsEmpty() -> Bool {
        print(#fileID, #function, #line)
        if selectedColor == nil {
            return true
        }
        return false
    }
}
