//
//  TrackersPresenter.swift
//  TrackerNew
//
//  Created by gimon on 30.06.2024.
//

import Foundation

final class TrackersPresenter: TrackersPresenterProtocol {
    // MARK: - Public Properties
    weak var trackersViewController: TrackersViewControllerProtocol?
    
    // MARK: - Private Properties
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var trackerRecords: [TrackerRecord] = []
    private var currentDate: Date = Date()
    private let calendar = Calendar.current
    
    // MARK: - Public Methods
    func getCurrentDate() -> Date {
        print(#fileID, #function, #line, "currentDate: \(currentDate)")
        return currentDate
    }
    
    func setCurrentDate(date: Date) {
        print(#fileID, #function, #line, "sdate: \(date)")
        currentDate = date
    }
    
    func getCountCategories() -> Int {
        print(#fileID, #function, #line, "categories.count: \(categories.count)")
        return categories.count
    }
    
    func getCountTrackersInCategoriesInCurentDate() -> Int {
        
        if categories.isEmpty {
            print(#fileID, #function, #line)
            return 0
        }
        
        let weekday = calendar.component(.weekday, from: currentDate)
        guard let day = Weekdays(rawValue: weekday) else {
            print(#fileID, #function, #line)
            return 0
        }
        
        let countTrackersInCategoriesInDate = categories[0].trackers.filter{
            $0.schedule.contains(day)
        }.count
        print(#fileID, #function, #line, "countTrackersInCategoriesInDate: \(countTrackersInCategoriesInDate)")
        return countTrackersInCategoriesInDate
    }
    
    func getTrackersInDate(index: Int) -> Tracker? {
        
        if categories.isEmpty {
            print(#fileID, #function, #line)
            return nil
        }
        
        let weekday = calendar.component(.weekday, from: currentDate)
        guard let day = Weekdays(rawValue: weekday) else {
            print(#fileID, #function, #line)
            return nil
        }
        
        let arrayTracersDay:[Tracker] = {
            categories[0].trackers.filter{
                $0.schedule.contains(day)
            }
        }()
        
        print(#fileID, #function, #line, "arrayTracersDay[index]: \(arrayTracersDay[index])")
        return arrayTracersDay[index]
    }
    
    func setTracker(tracker: Tracker) {
        print(#fileID, #function, #line)
        if categories.isEmpty {
            categories.append(
                TrackerCategory(
                    name: "Test Category",
                    trackers: [tracker]
                )
            )
        } else {
            categories = [
                TrackerCategory(
                    name: "Test Category",
                    trackers: (categories[0].trackers + [tracker])
                )
            ]
        }
    }
    
    func getNameCategory(index: Int) -> String {
        print(#fileID, #function, #line)
        return categories[0].name
    }
    
    func setTrackerRecordDate(id: UInt) {
        print(#fileID, #function, #line)
        guard let index = trackerRecords.firstIndex(where: {$0.id == id}) else {
            let trackerRecord = TrackerRecord(
                id: id,
                dates: Set<Date>(arrayLiteral: currentDate)
            )
            trackerRecords.append(trackerRecord)
            return
        }
        
        var dates: Set<Date> = trackerRecords[index].dates
        dates.insert(currentDate)
        trackerRecords.remove(at: index)
        let trackerRecord = TrackerRecord(
            id: id,
            dates: dates
        )
        trackerRecords.append(trackerRecord)
    }
    
    func deleteTrackerRecordDate(id: UInt) {
        print(#fileID, #function, #line)
        guard let index = trackerRecords.firstIndex(where: {$0.id == id}) else {
            return
        }
        
        var dates: Set<Date> = trackerRecords[index].dates
        dates.remove(currentDate)
        trackerRecords.remove(at: index)
        let trackerRecord = TrackerRecord(
            id: id,
            dates: dates
        )
        trackerRecords.append(trackerRecord)
    }
    
    func countTrackerRecordDate(id: UInt) -> String {
        print(#fileID, #function, #line)
        guard let index = trackerRecords.firstIndex(where: {$0.id == id}) else {
            return "0 дней"
        }
        let count = trackerRecords[index].dates.count
        let suffix: String
        
        if count % 10 == 1 && count % 100 != 11 {
            suffix = "день"
        } else if (count % 10 == 2 && count % 100 != 12) ||
                    (count % 10 == 3 && count % 100 != 13) ||
                    (count % 10 == 4 && count % 100 != 14) {
            suffix = "дня"
        } else {
            suffix = "дней"
        }
        return "\(count) \(suffix)"
    }
    
    func containTrackerRecordDate(id: UInt) -> Bool {
        print(#fileID, #function, #line)
        guard let _ = trackerRecords.firstIndex(where: {
            $0.id == id && $0.dates.contains(currentDate)
        }) else {
            return false
        }
        return true
    }
}
