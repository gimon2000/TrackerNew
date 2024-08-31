//
//  TrackerCategoryStore.swift
//  TrackerNew
//
//  Created by gimon on 11.07.2024.
//

import UIKit
import CoreData

// MARK: - CategoryDataProviderDelegate
protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategory()
}

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Public Properties
    let context: NSManagedObjectContext
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Private Properties
    private let uiColorMarshalling = UIColorMarshalling()
    private let daysValueTransformer = DaysValueTransformer()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    // MARK: - Initializers
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func getTrackerCategoryCoreData(categoryName: String) -> TrackerCategoryCoreData {
        
        guard let trackerCategoryCoreData = fetchTrackerCategoryCoreData(categoryName: categoryName) else {
            
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.name = categoryName
            print(#fileID, #function, #line, "trackerCategoryCoreData: \(trackerCategoryCoreData)")
            return trackerCategoryCoreData
        }
        print(#fileID, #function, #line, "trackerCategoryCoreData: \(trackerCategoryCoreData)")
        return trackerCategoryCoreData
    }
    
    func addCategoryCoreData(name: String) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = name
        print(#fileID, #function, #line, "trackerCategoryCoreData: \(trackerCategoryCoreData)")
        saveContext()
    }
    
    func fetchTrackerCategoryCoreData(categoryName: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "name == %@", categoryName)
        
        do {
            let result = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, "result: \(result)")
            return result.first
        } catch {
            print(#fileID, #function, #line, "result: nil")
            return nil
        }
    }
    
    func cleanLastCategoryCoreData(){
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "isLast == true")
        
        do {
            let result = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, "result: \(result)")
            result.first?.isLast = false
            saveContext()
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    func addLastCategoryCoreData(categoryName: String){
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(format: "name == %@", categoryName)
        
        do {
            let result = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, "result: \(result)")
            result.first?.isLast = true
            saveContext()
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    func getCountTrackerCategoryCoreData() -> Int {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        
        do {
            let category = try context.fetch(fetchRequest)
            let count = category.first?.tracker?.count as? Int ?? 0
            print(#fileID, #function, #line, "count: \(count)")
            return count
        } catch {
            print(#fileID, #function, #line, "count: 0 catch")
            return 0
        }
    }
    
    func isCategoryCoreDataEmpty() -> Bool {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        
        do {
            let category = try context.fetch(fetchRequest)
            let isEmpty = category.isEmpty
            print(#fileID, #function, #line, "isEmpty: \(isEmpty)")
            return isEmpty
        } catch {
            print(#fileID, #function, #line, "isEmpty: catch")
            return true
        }
    }
    
    func getCountCategoryCoreData() -> Int {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        
        do {
            let category = try context.fetch(fetchRequest)
            let count = category.count
            print(#fileID, #function, #line, "count: \(count)")
            return count
        } catch {
            print(#fileID, #function, #line, "count: 0 catch")
            return 0
        }
    }
    
    func getArrayNameCategoryCoreData() -> [(String, Bool)] {
        let category = getCategories()
        guard let category else {
            return []
        }
        var array: [(String, Bool)] = []
        
        category.forEach{
            if let name = $0.name {
                let isLast = $0.isLast
                array.append((name, isLast))
            }
        }
        
        return array
    }
    
    func getNameTrackerCategoryCoreData(index: Int) -> String {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        
        do {
            let categorys = try context.fetch(fetchRequest)
            let name: String = categorys[index].name ?? ""
            print(#fileID, #function, #line, "name: \(name)")
            return name
        } catch {
            print(#fileID, #function, #line, error)
            return ""
        }
    }
    
    
    func getCountTrackersInTrackerCategoryCoreDataIn(
        currentWeekday: Weekdays,
        currentDate: Date,
        categoryName: String
    ) -> Int {
        
        let count = getArrayTrackers(
            categoryName: categoryName,
            currentWeekday: currentWeekday,
            currentDate: currentDate
        )?.count
        print(#fileID, #function, #line, count as Any)
        return count ?? 0
    }
    
    func getCountTrackersInTrackerCategoryCoreDataIn(
        currentWeekday: Weekdays,
        currentDate: Date,
        inSection: Int
    ) -> Int {
        guard let category = getCategories() else {
            return 0
        }
        
        let names = category.compactMap{
            $0.name
        }
        
        let namesInDate = names.compactMap{
            getArrayTrackers(
                categoryName: $0,
                currentWeekday: currentWeekday,
                currentDate: currentDate
            )?.count
        }
        
        return namesInDate[inSection]
    }
    
    func getNameCategoryCoreDataIn(
        currentWeekday: Weekdays,
        currentDate: Date,
        inSection: Int
    ) -> String {
        
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        
        do {
            let category = try context.fetch(fetchRequest)
            let name = category.filter{
                guard let nameCategory = $0.name else { return false }
                let countTrackers = getArrayTrackers(
                    categoryName: nameCategory,
                    currentWeekday: currentWeekday,
                    currentDate: currentDate
                )?.count ?? 0
                print(#fileID, #function, #line, countTrackers as Any)
                return countTrackers > 0
            }[inSection].name ?? "Error getCountTrackersInTrackerCategoryCoreDataIn"
            print(#fileID, #function, #line, "name: \(name)")
            return name
        } catch {
            print(#fileID, #function, #line, "name: catch")
            return ""
        }
    }
    
    func getCountCategoryCoreDataIn(
        currentWeekday: Weekdays,
        currentDate: Date
    ) -> Int {
        guard let category = getCategories() else {
            return 0
        }
        let count = category.filter{
            guard let nameCategory = $0.name else { return false }
            let countTrackers = getArrayTrackers(
                categoryName: nameCategory,
                currentWeekday: currentWeekday,
                currentDate: currentDate
            )?.count ?? 0
            print(#fileID, #function, #line, countTrackers as Any)
            return countTrackers > 0
        }.count
        print(#fileID, #function, #line, "count: \(count)")
        return count
    }
    
    func getTrackerInDate(
        currentWeekday: Weekdays,
        currentDate: Date,
        indexSection: Int,
        indexTracker: Int
    ) -> Tracker? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        
        do {
            let category = try context.fetch(fetchRequest)
            let trackersCoreData = category.filter{
                guard let nameCategory = $0.name else { return false }
                let countTrackers = getArrayTrackers(
                    categoryName: nameCategory,
                    currentWeekday: currentWeekday,
                    currentDate: currentDate
                )?.count ?? 0
                print(#fileID, #function, #line, countTrackers as Any)
                return countTrackers > 0
            }[indexSection].tracker?.filter{
                if let _ = $0 as? TrackerCoreData {
                    return true
                }
                return false
            }
            
            guard let trackerCoreData = trackersCoreData?[indexTracker] as? TrackerCoreData else {
                print(#fileID, #function, #line)
                return nil
            }
            
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
        } catch {
            print(#fileID, #function, #line, "name: catch")
            return nil
        }
    }
    
    func getCategories() -> [TrackerCategoryCoreData]? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        
        do {
            let categories = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, "categories: \(categories)")
            return categories
        } catch {
            print(#fileID, #function, #line, "categories: \(error)")
            return nil
        }
    }
    
    // MARK: - Private Methods
    private func deleteAllEntity() {
        let nSFetchRequestTracker = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        let nSBatchDeleteRequestTracker = NSBatchDeleteRequest(fetchRequest: nSFetchRequestTracker)
        try! context.execute(nSBatchDeleteRequestTracker)
        
        let nSFetchRequestCategory = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryCoreData")
        let nSBatchDeleteRequestCategory = NSBatchDeleteRequest(fetchRequest: nSFetchRequestCategory)
        try! context.execute(nSBatchDeleteRequestCategory)
        
        let nSFetchRequestRecord = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerRecordCoreData")
        let nSBatchDeleteRequestRecord = NSBatchDeleteRequest(fetchRequest: nSFetchRequestRecord)
        try! context.execute(nSBatchDeleteRequestRecord)
        saveContext()
    }
    
    private func dateIgnoreTime (date: Date?) -> Date? {
        guard let date else {
            return nil
        }
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let dateWithoutTime = Calendar.current.date(from: dateComponents)
        return dateWithoutTime
    }
    
    private func getArrayTrackers(categoryName: String, currentWeekday: Weekdays, currentDate: Date) -> [TrackerCoreData]? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = fetchedResultsController.fetchRequest
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.name),
            categoryName
        )
        print(#fileID, #function, #line, fetchRequest.predicate as Any)
        let category = try! context.fetch(fetchRequest)
        let arrayTrackers = category.first?.tracker?.filter {
            if let tracker = $0 as? TrackerCoreData {
                print(#fileID, #function, #line, tracker.schedule as Any)
                if let schedule = daysValueTransformer.reverseTransformedValue(tracker.schedule) as? [Weekdays] {
                    print(#fileID, #function, #line, schedule)
                    print(#fileID, #function, #line, schedule.contains(currentWeekday))
                    return schedule.contains(currentWeekday)
                }
                if let eventDate = tracker.eventDate {
                    return dateIgnoreTime(date: eventDate) == dateIgnoreTime(date: currentDate)
                }
                return false
            }
            return false
        }
        return arrayTrackers as? [TrackerCoreData]
    }
    
    // MARK: - Core Data Saving support
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print(#fileID, #function, #line)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategory()
    }
}
