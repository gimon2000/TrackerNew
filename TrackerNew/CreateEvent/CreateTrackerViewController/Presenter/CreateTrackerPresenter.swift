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
    
    // MARK: - Private Properties
    private var weekdaysChecked: [Weekdays]?
    private let category: String = "Тест"
    private var selectedEmoji: String = ""
    private let color: UIColor = .red
    
    // MARK: - Public Methods
    func createTracker(name: String) {
        print(#fileID, #function, #line)
        if let weekdaysChecked = weekdaysChecked {
            let tracker = Tracker(
                id: UInt.random(in: 0...UInt.max),
                name: name,
                emoji: selectedEmoji,
                color: color,
                schedule: weekdaysChecked,
                eventDate: nil
            )
            createTrackerView?.delegate?.setTracker(tracker: tracker, category: category)
        } else {
            let tracker = Tracker(
                id: UInt.random(in: 0...UInt.max),
                name: name,
                emoji: selectedEmoji,
                color: color,
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
    
    func selectedEmojiIsEmpty() -> Bool {
        print(#fileID, #function, #line)
        return !arrayEmojis.contains(selectedEmoji)
    }
}
