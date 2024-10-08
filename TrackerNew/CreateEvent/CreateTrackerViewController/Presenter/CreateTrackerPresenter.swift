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
    private var category: String = ""
    private var selectedEmoji: String = ""
    private var selectedColor: UIColor?
    private var trackerId: UInt?
    
    // MARK: - Public Methods
    func setParam(
        oldWeekdaysChecked: [Weekdays],
        oldCategory: String,
        oldSelectedEmoji: String,
        oldSelectedColor: UIColor,
        oldTrackerId: UInt
    ){
        weekdaysChecked = oldWeekdaysChecked
        category = oldCategory
        selectedEmoji = oldSelectedEmoji
        selectedColor = oldSelectedColor
        trackerId = oldTrackerId
    }
    
    func getIndexSelectedEmoji() -> Int? {
        if selectedEmoji.isEmpty {
            return nil
        }
        return arrayEmojis.firstIndex(where: {$0 == selectedEmoji})
    }
    
    func getIndexSelectedColor() -> Int? {
        guard let selectedColor else {
            return nil
        }
        return arrayColors.firstIndex(where: {compareColors(c1: $0, c2: selectedColor) })
    }
    
    func createTracker(name: String) {
        print(#fileID, #function, #line)
        if let weekdaysChecked = weekdaysChecked {
            let tracker = Tracker(
                id: trackerId ?? UInt.random(in: 0...UInt(Int32.max)),
                name: name,
                emoji: selectedEmoji,
                color: selectedColor ?? .red,
                schedule: weekdaysChecked,
                eventDate: nil
            )
            createTrackerView?.delegate?.setTracker(tracker: tracker, category: category)
            createTrackerView?.trackersDelegate?.changeTracker(tracker: tracker, category: category)
        } else {
            let tracker = Tracker(
                id: trackerId ?? UInt.random(in: 0...UInt(Int32.max)),
                name: name,
                emoji: selectedEmoji,
                color: selectedColor ?? .red,
                schedule: nil,
                eventDate: Date()
            )
            createTrackerView?.delegate?.setTracker(tracker: tracker, category: category)
            createTrackerView?.trackersDelegate?.changeTracker(tracker: tracker, category: category)
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
    
    func setCategoryChecked(nameCategory: String) {
        self.category = nameCategory
        print(
            #fileID,
            #function,
            #line,
            "self.category: \(String(describing: self.category))"
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
    
    func categoryCheckedIsEmpty() -> Bool {
        print(#fileID, #function, #line, "category.isEmpty: \(category.isEmpty)")
        return category.isEmpty
    }
    
    func getSubtitleSchedule() -> String {
        print(#fileID, #function, #line)
        guard let weekdaysChecked else {
            print(#fileID, #function, #line)
            return ""
        }
        return weekdaysChecked.map{ $0.shortName }.joined(separator: ", ")
    }
    
    func getSubtitleCategory() -> String {
        print(#fileID, #function, #line)
        return category
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
    
    private func compareColors (c1:UIColor, c2:UIColor) -> Bool{
        var red:CGFloat = 0
        var green:CGFloat  = 0
        var blue:CGFloat = 0
        var alpha:CGFloat  = 0
        c1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var red2:CGFloat = 0
        var green2:CGFloat  = 0
        var blue2:CGFloat = 0
        var alpha2:CGFloat  = 0
        c2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return (Int(red*255) == Int(red*255) && Int(green*255) == Int(green2*255) && Int(blue*255) == Int(blue*255) )
    }
}
