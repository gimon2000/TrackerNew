//
//  TrackerStore.swift
//  TrackerNew
//
//  Created by gimon on 14.07.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private let daysValueTransformer = DaysValueTransformer()
    private let coreDataStore = TrackerCategoryStore()
    
    // MARK: - Initializers
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func addTrackerInCoreData(tracker: Tracker, categoryName: String) throws {
        let category = coreDataStore.getTrackerCategoryCoreData(categoryName: categoryName)
        
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.name = tracker.name
        trackerCoreData.idTracker = Int32(tracker.id)
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.eventDate = tracker.eventDate
        trackerCoreData.schedule = daysValueTransformer.transformedValue(tracker.schedule) as? NSObject
        
        trackerCoreData.trackerCategory = category
        
        print(#fileID, #function, #line, "trackerCoreData: \(trackerCoreData)")
        
        saveContext()
    }
    
    func changeTrackerInCoreData(tracker: Tracker, categoryName: String) {
        let category = coreDataStore.getTrackerCategoryCoreData(categoryName: categoryName)
        
        let fetchRequest: NSFetchRequest<TrackerCoreData> = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "idTracker == %d", tracker.id)
        
        do {
            let result = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, "result: \(result)")
            if let oldTracker = result.first {
                if let schedule = tracker.schedule, !schedule.isEmpty {
                    oldTracker.schedule = daysValueTransformer.transformedValue(schedule) as? NSObject
                }
                oldTracker.color = uiColorMarshalling.hexString(from: tracker.color)
                oldTracker.emoji = tracker.emoji
                oldTracker.name = tracker.name
                oldTracker.trackerCategory = category
                
                saveContext()
            }
        } catch {
            print(#fileID, #function, #line, "result: nil")
        }
    }
    
    func deleteTracker(id: UInt) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "idTracker == %d", id)
        
        do {
            let result = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, "result: \(result)")
            if let tracker = result.first {
                context.delete(tracker)
                saveContext()
            }
        } catch {
            print(#fileID, #function, #line, "result: nil")
        }
    }
    
    func changeCategoryInTrackerCoreData(categoryName: String, idTracker: UInt) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "idTracker == %d", idTracker)
        
        do {
            let result = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, "result: \(result)")
            
            if categoryName == "Закрепленные" {
                let oldCategory = result.first?.oldTrackerCategory
                result.first?.trackerCategory = oldCategory
            } else {
                let categoryFix = coreDataStore.getTrackerCategoryCoreData(categoryName: "Закрепленные")
                let oldCategory = result.first?.trackerCategory
                result.first?.oldTrackerCategory = oldCategory
                result.first?.trackerCategory = categoryFix
            }
            saveContext()
        } catch {
            print(#fileID, #function, #line, "result: nil")
        }
    }
    
    // MARK: - Core Data Saving support
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print(#fileID, #function, #line)
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
