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
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
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
        return trackerCategoryStore.getCountTrackerCategoryCoreData()
    }
    
    func getCountTrackersInCategoriesInCurrentDate() -> Int {
        
        if trackerCategoryStore.getCountTrackerCategoryCoreData() == 0 {
            print(#fileID, #function, #line)
            return 0
        }
        
        let weekday = calendar.component(.weekday, from: currentDate)
        guard let day = Weekdays(rawValue: weekday) else {
            print(#fileID, #function, #line)
            return 0
        }
        
        return trackerCategoryStore.getCountTrackersInTrackerCategoryCoreDataIn(
            currentWeekday: day,
            currentDate: currentDate,
            categoryName: "Тест"
        )
    }
    
    func getTrackersInDate(index: Int) -> Tracker? {
        
        if trackerCategoryStore.getCountTrackerCategoryCoreData() == 0 {
            print(#fileID, #function, #line)
            return nil
        }
        
        let weekday = calendar.component(.weekday, from: currentDate)
        guard let day = Weekdays(rawValue: weekday) else {
            print(#fileID, #function, #line)
            return nil
        }
        
        return trackerCategoryStore.getTrackerInDate(
            currentWeekday: day,
            currentDate: currentDate,
            index: index,
            categoryName: "Тест"
        )
    }
    
    func setTracker(tracker: Tracker, category: String) {
        print(#fileID, #function, #line)
        do {
            try trackerStore.addTrackerInCoreData(tracker: tracker, categoryName: category)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getNameCategory(index: Int) -> String {
        print(#fileID, #function, #line)
        return trackerCategoryStore.getNameTrackerCategoryCoreData(index: 0)
    }
    
    func setTrackerCompletedTrackers(id: UInt) {
        print(#fileID, #function, #line)
        trackerRecordStore.setTrackerCompletedTrackers(currentDate: currentDate, id: id)
    }
    
    func deleteTrackerCompletedTrackers(id: UInt) {
        print(#fileID, #function, #line)
        trackerRecordStore.deleteTrackerCompletedTrackers(currentDate: currentDate, id: id)
    }
    
    func countTrackerCompletedTrackers(id: UInt) -> String {
        print(#fileID, #function, #line)
        let count = trackerRecordStore.countTrackerCompletedTrackers(id: id)
        
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
        
        // TODO: core data
        return trackerRecordStore.containTrackerCompletedTrackers(
            currentDate: currentDate,
            id: id
        )
    }
}
