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
    private lazy var currentDateForFilter: Date = Date()
    private var isCurrentDateFilterOn = false
    private var isCompletedFilterOn = false
    private var isUncompletedFilterOn = false
    private let calendar = Calendar.current
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()
    private lazy var trackerRecordStore = TrackerRecordStore()
    private let daysValueTransformer = DaysValueTransformer()
    private let uiColorMarshalling = UIColorMarshalling()
    private lazy var categories: [TrackerCategoryCoreData]? = trackerCategoryStore.getCategories()
    private var visibleCategories: [TrackerCategory] = []
    private var searchText = ""
    
    init() {
        self.trackerCategoryStore.delegate = self
        self.trackerRecordStore.delegate = self
    }
    
    // MARK: - Public Methods
    func cleanAllFilters() {
        print(#fileID, #function, #line)
        isCurrentDateFilterOn = false
        isCompletedFilterOn = false
        isUncompletedFilterOn = false
        visibleCategories = getCategoryInCurrentDay()
    }
    
    func todayFilter() {
        print(#fileID, #function, #line)
        cleanAllFilters()
        isCurrentDateFilterOn = true
    }
    
    func completedFilter() {
        print(#fileID, #function, #line)
        cleanAllFilters()
        isCompletedFilterOn = true
        visibleCategories = getCategoryInCurrentDay()
    }
    
    func uncompletedFilter() {
        print(#fileID, #function, #line)
        cleanAllFilters()
        isUncompletedFilterOn = true
        visibleCategories = getCategoryInCurrentDay()
    }
    
    func getCurrentDate() -> Date {
        let date = isCurrentDateFilterOn ? currentDateForFilter : currentDate
        print(#fileID, #function, #line, "currentDate: \(date)")
        return date
    }
    
    func setCurrentDate(date: Date) {
        print(#fileID, #function, #line, "sdate: \(date)")
        currentDate = date
    }
    
    func setSearchText(text: String) {
        print(#fileID, #function, #line, "text: \(text)")
        searchText = text
    }
    
    func getCountCategories() -> Int {
        guard let categories else {
            return 0
        }
        print(#fileID, #function, #line, "categories.count: \(categories.count)")
        return categories.count
    }
    
    func getCountTrackersInCategoriesInCurrentDate(inSection: Int) -> Int {
        let count = visibleCategories[inSection].trackers.count
        print(#fileID, #function, #line, "count: \(count)")
        return count
    }
    
    func getCountCategoriesInCurrentDate() -> Int {
        visibleCategories = getCategoryInCurrentDay()
        let index = visibleCategories.firstIndex(where: {$0.name == "Закрепленные"})
        if let index, index != 0 {
            visibleCategories.swapAt(index, 0)
        }
        let count = visibleCategories.count
        print(#fileID, #function, #line, "count: \(count)")
        return count
        
    }
    
    func getTrackersInDate(indexSection: Int, indexTracker: Int) -> Tracker? {
        let tracker = visibleCategories[indexSection].trackers[indexTracker]
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
    
    func changeTracker(tracker: Tracker, category: String) {
        print(#fileID, #function, #line)
        trackerStore.changeTrackerInCoreData(tracker: tracker, categoryName: category)
        categories = trackerCategoryStore.getCategories()
    }
    
    func deleteTracker(id: UInt) {
        print(#fileID, #function, #line)
        trackerStore.deleteTracker(id: id)
        categories = trackerCategoryStore.getCategories()
    }
    
    func changeCategoryInTrackerCoreData(categoryName: String, idTracker: UInt) {
        print(#fileID, #function, #line, "categoryName: \(categoryName), idTracker: \(idTracker)")
        trackerStore.changeCategoryInTrackerCoreData(categoryName: categoryName, idTracker: idTracker)
    }
    
    func getNameCategory(index: Int) -> String {
        let nameCategory = visibleCategories[index].name
        print(#fileID, #function, #line, "nameCategory: \(nameCategory)")
        return nameCategory
    }
    
    func setTrackerCompletedTrackers(id: UInt) {
        print(#fileID, #function, #line)
        let date = isCurrentDateFilterOn ? currentDateForFilter : currentDate
        trackerRecordStore.setTrackerCompletedTrackers(currentDate: date, id: id)
    }
    
    func deleteTrackerCompletedTrackers(id: UInt) {
        print(#fileID, #function, #line)
        let date = isCurrentDateFilterOn ? currentDateForFilter : currentDate
        trackerRecordStore.deleteTrackerCompletedTrackers(currentDate: date, id: id)
    }
    
    func countTrackerCompletedTrackers(id: UInt) -> String {
        print(#fileID, #function, #line)
        let count = trackerRecordStore.countTrackerCompletedTrackers(id: id)
        
        let daysString = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of completed days"),
            count
        )
        
        return daysString
    }
    
    func containTrackerCompletedTrackers(id: UInt) -> Bool {
        print(#fileID, #function, #line)
        let date = isCurrentDateFilterOn ? currentDateForFilter : currentDate
        return trackerRecordStore.containTrackerCompletedTrackers(
            currentDate: date,
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
        let date = isCurrentDateFilterOn ? currentDateForFilter : currentDate
        let weekday = calendar.component(.weekday, from: date)
        guard let day = Weekdays(rawValue: weekday) else {
            assertionFailure("getCurrentWeekday")
            return Weekdays.friday
        }
        return day
    }
    
    private func getCategoryInCurrentDay() -> [TrackerCategory]{
        let day = getCurrentWeekday()
        
        return categories?.compactMap{
            if let trackersCoreData = $0.tracker, let categoryName = $0.name {
                var trackersInDate = trackersCoreData.filter{
                    if let tracker = $0 as? TrackerCoreData {
                        print(#fileID, #function, #line, tracker.schedule as Any)
                        if let schedule = daysValueTransformer.reverseTransformedValue(tracker.schedule) as? [Weekdays] {
                            print(#fileID, #function, #line, schedule)
                            print(#fileID, #function, #line, schedule.contains(day))
                            return schedule.contains(day)
                        }
                        if let eventDate = tracker.eventDate {
                            let date = isCurrentDateFilterOn ? currentDateForFilter : currentDate
                            return dateIgnoreTime(date: eventDate) == dateIgnoreTime(date: date)
                        }
                        return false
                    }
                    return false
                }
                
                if !searchText.isEmpty {
                    trackersInDate = trackersInDate.filter{
                        if let tracker = $0 as? TrackerCoreData {
                            if let name = tracker.name {
                                let contain = name.lowercased().contains(searchText.lowercased())
                                print(#fileID, #function, #line, "contain: \(contain)")
                                return contain
                            }
                            return false
                        }
                        return false
                    }
                }
                
                if isCompletedFilterOn {
                    trackersInDate = trackersInDate.filter{
                        if let tracker = $0 as? TrackerCoreData {
                            let id = tracker.idTracker
                            let contain = containTrackerCompletedTrackers(id: UInt(id))
                            print(#fileID, #function, #line, "contain: \(contain)")
                            return contain
                        }
                        return false
                    }
                }
                
                if isUncompletedFilterOn {
                    trackersInDate = trackersInDate.filter{
                        if let tracker = $0 as? TrackerCoreData {
                            let id = tracker.idTracker
                            let contain = !containTrackerCompletedTrackers(id: UInt(id))
                            print(#fileID, #function, #line, "contain: \(contain)")
                            return contain
                        }
                        return false
                    }
                }
                
                let trackers: [Tracker] = trackersInDate.compactMap{
                    if let tracker = $0 as? TrackerCoreData {
                        var schedules: [Weekdays]?
                        if let schedule = daysValueTransformer.reverseTransformedValue(tracker.schedule) as? [Weekdays]? {
                            schedules = schedule
                        }
                        
                        let tracker = Tracker(
                            id: UInt(tracker.idTracker),
                            name: tracker.name ?? "",
                            emoji: tracker.emoji ?? "",
                            color: uiColorMarshalling.color(from: tracker.color ?? ""),
                            schedule: schedules,
                            eventDate: tracker.eventDate
                        )
                        return tracker
                    }
                    return nil
                }
                
                if !trackers.isEmpty {
                    return TrackerCategory(name: categoryName, trackers: trackers)
                }
                return nil
            }
            return nil
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
