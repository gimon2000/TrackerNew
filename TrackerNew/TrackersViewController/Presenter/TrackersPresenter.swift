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
            
            guard let schedule = $0.schedule else {
                print(#fileID, #function, #line)
                guard let trackerDate = dateIgnoreTime(date: $0.eventDate),
                      let selfDate = dateIgnoreTime(date: currentDate) else {
                    return false
                }
                if trackerDate == selfDate {
                    return true
                }
                return false
            }
            
            return schedule.contains(day)
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
                guard let schedule = $0.schedule else {
                    print(#fileID, #function, #line)
                    guard let trackerDate = dateIgnoreTime(date: $0.eventDate),
                          let selfDate = dateIgnoreTime(date: currentDate) else {
                        return false
                    }
                    if trackerDate == selfDate {
                        return true
                    }
                    return false
                }
                
                return schedule.contains(day)
            }
        }()
        
        print(#fileID, #function, #line, "arrayTracersDay[index]: \(arrayTracersDay[index])")
        return arrayTracersDay[index]
    }
    
    func setTracker(tracker: Tracker, category: String) {
        print(#fileID, #function, #line)
        if categories.isEmpty {
            categories.append(
                TrackerCategory(
                    name: category,
                    trackers: [tracker]
                )
            )
        } else {
            categories = [
                TrackerCategory(
                    name: category,
                    trackers: (categories[0].trackers + [tracker])
                )
            ]
        }
    }
    
    func getNameCategory(index: Int) -> String {
        print(#fileID, #function, #line)
        return categories[0].name
    }
    
    func setTrackerCompletedTrackers(id: UInt) {
        print(#fileID, #function, #line)
        guard let index = completedTrackers.firstIndex(where: {$0.id == id}) else {
            let trackerRecord = TrackerRecord(
                id: id,
                dates: Set<Date>(arrayLiteral: currentDate)
            )
            completedTrackers.append(trackerRecord)
            return
        }
        
        var dates: Set<Date> = completedTrackers[index].dates
        dates.insert(currentDate)
        completedTrackers.remove(at: index)
        let trackerRecord = TrackerRecord(
            id: id,
            dates: dates
        )
        completedTrackers.append(trackerRecord)
    }
    
    func deleteTrackerCompletedTrackers(id: UInt) {
        print(#fileID, #function, #line)
        guard let index = completedTrackers.firstIndex(where: {$0.id == id}) else {
            return
        }
        
        var dates: Set<Date> = completedTrackers[index].dates
        dates.remove(currentDate)
        completedTrackers.remove(at: index)
        let trackerRecord = TrackerRecord(
            id: id,
            dates: dates
        )
        completedTrackers.append(trackerRecord)
    }
    
    func countTrackerCompletedTrackers(id: UInt) -> String {
        print(#fileID, #function, #line)
        guard let index = completedTrackers.firstIndex(where: {$0.id == id}) else {
            return "0 дней"
        }
        let count = completedTrackers[index].dates.count
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
    
    func containTrackerCompletedTrackers(id: UInt) -> Bool {
        print(#fileID, #function, #line)
        guard let _ = completedTrackers.firstIndex(where: {
            $0.id == id && $0.dates.contains(currentDate)
        }) else {
            return false
        }
        return true
    }
    
    // MARK: - Private Methods
    private func dateIgnoreTime (date: Date?) -> Date? {
        guard let date else {
            return nil
        }
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let dateWithoutTime = Calendar.current.date(from: dateComponents)
        return dateWithoutTime
    }
}
