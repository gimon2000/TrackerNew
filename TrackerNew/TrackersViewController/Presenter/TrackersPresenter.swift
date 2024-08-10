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
    private lazy var currentDate: Date = Date()
    private let calendar = Calendar.current
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()
    private lazy var trackerRecordStore = TrackerRecordStore()
    private let daysValueTransformer = DaysValueTransformer()
    private let uiColorMarshalling = UIColorMarshalling()
    private lazy var categories: [TrackerCategoryCoreData]? = trackerCategoryStore.getCategories()
    
    init() {
        self.trackerCategoryStore.delegate = self
        self.trackerRecordStore.delegate = self
    }
    
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
        guard let categories else {
            return 0
        }
        print(#fileID, #function, #line, "categories.count: \(categories.count)")
        return categories.count
    }
    
    func getCountTrackersInCategoriesInCurrentDate(inSection: Int) -> Int {
        
        let categoriesInDate = getCategoryCoreDataInCurrentDay()
        let trackers = categoriesInDate[inSection].tracker
        
        let count = trackers?.count ?? 0
        print(#fileID, #function, #line, "count: \(count)")
        return count
    }
    
    func getCountCategoriesInCurrentDate() -> Int {
        
        let categoriesInDate = getCategoryCoreDataInCurrentDay()
        
        let count = categoriesInDate.count
        print(#fileID, #function, #line, "count: \(count)")
        return count
        
    }
    
    func getTrackersInDate(indexSection: Int, indexTracker: Int) -> Tracker? {
        
        let categoriesInDate = getCategoryCoreDataInCurrentDay()
        guard let trackers = categoriesInDate[indexSection].tracker as? Set<TrackerCoreData> else {
            return nil
        }
        let trackerCoreData = Array(trackers)[indexTracker]
        
        var schedules: [Weekdays]?
        if let schedule = daysValueTransformer.reverseTransformedValue(trackerCoreData.schedule) as? [Weekdays]? {
            schedules = schedule
        }
        
        let tracker = Tracker(
            id: UInt(trackerCoreData.idTracker),
            name: trackerCoreData.name ?? "",
            emoji: trackerCoreData.emoji ?? "",
            color: uiColorMarshalling.color(from: trackerCoreData.color ?? ""),
            schedule: schedules,
            eventDate: trackerCoreData.eventDate
        )
        
        print(#fileID, #function, #line, "tracker: \(tracker)")
        return tracker
    }
    
    func setTracker(tracker: Tracker, category: String) {
        print(#fileID, #function, #line)
        do {
            try trackerStore.addTrackerInCoreData(tracker: tracker, categoryName: category)
            categories = trackerCategoryStore.getCategories()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getNameCategory(index: Int) -> String {
        print(#fileID, #function, #line)
        
        guard let categories else {
            print(#fileID, #function, #line)
            assertionFailure("Error getNameCategory")
            return "Error getNameCategory"
        }
        
        guard let nameCategory = categories[index].name else {
            print(#fileID, #function, #line)
            assertionFailure("Error getNameCategory")
            return "Error getNameCategory"
        }
        print(#fileID, #function, #line, "nameCategory: \(nameCategory)")
        return nameCategory
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
        
        return trackerRecordStore.containTrackerCompletedTrackers(
            currentDate: currentDate,
            id: id
        )
    }
    
    private func dateIgnoreTime (date: Date?) -> Date? {
        print(#fileID, #function, #line)
        guard let date else {
            print(#fileID, #function, #line)
            return nil
        }
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let dateWithoutTime = Calendar.current.date(from: dateComponents)
        return dateWithoutTime
    }
    
    private func getCurrentWeekday() -> Weekdays {
        print(#fileID, #function, #line)
        let weekday = calendar.component(.weekday, from: currentDate)
        guard let day = Weekdays(rawValue: weekday) else {
            assertionFailure("getCurrentWeekday")
            return Weekdays.friday
        }
        return day
    }
    
    private func getCategoryCoreDataInCurrentDay() -> [TrackerCategoryCoreData]{
        let day = getCurrentWeekday()
        
        return categories?.filter{
            if let trackers = $0.tracker {
                return !trackers.filter{
                    if let tracker = $0 as? TrackerCoreData {
                        print(#fileID, #function, #line, tracker.schedule as Any)
                        if let schedule = daysValueTransformer.reverseTransformedValue(tracker.schedule) as? [Weekdays] {
                            print(#fileID, #function, #line, schedule)
                            print(#fileID, #function, #line, schedule.contains(day))
                            return schedule.contains(day)
                        }
                        if let eventDate = tracker.eventDate {
                            return dateIgnoreTime(date: eventDate) == dateIgnoreTime(date: currentDate)
                        }
                        return false
                    }
                    return false
                }.isEmpty
            }
            return false
        } ?? []
    }
}

extension TrackersPresenter: TrackerCategoryStoreDelegate {
    func didUpdateCategory() {
        trackersViewController?.collectionViewReloadData()
    }
}

extension TrackersPresenter: TrackerRecordStoreDelegate {
    func didUpdateRecord() {
        trackersViewController?.collectionViewReloadData()
    }
}
