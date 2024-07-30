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
