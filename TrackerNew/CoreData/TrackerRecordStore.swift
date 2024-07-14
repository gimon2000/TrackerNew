//
//  TrackerRecordStore.swift
//  TrackerNew
//
//  Created by gimon on 14.07.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private let daysValueTransformer = DaysValueTransformer()
    
    // MARK: - Initializers
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func setTrackerCompletedTrackers(currentDate: Date, id: UInt) {
        guard getTrackerRecordCoreData(currentDate: currentDate, id: id) != nil else {
            let trackerRecordCoreData = TrackerRecordCoreData(context: context)
            trackerRecordCoreData.idTracker = Int32(id)
            print(#fileID, #function, #line, "trackerCategoryCoreData: \(trackerRecordCoreData)")
            trackerRecordCoreData.date = currentDate
            print(#fileID, #function, #line, trackerRecordCoreData as Any)
            saveContext()
            return
        }
    }
    
    func getTrackerRecordCoreData(currentDate: Date, id: UInt) -> TrackerRecordCoreData? {
        let fetchRequest = getFetchRequest(id: id, currentDate: currentDate)
        print(#fileID, #function, #line, fetchRequest.predicate as Any)
        do {
            let records = try context.fetch(fetchRequest)
            if let record = records.first {
                print(#fileID, #function, #line, "record: \(record)")
                return record
            }
        } catch {
            print(#fileID, #function, #line, error)
        }
        print(#fileID, #function, #line)
        return nil
    }
    
    func deleteTrackerCompletedTrackers(currentDate: Date, id: UInt) {
        let fetchRequest = getFetchRequest(id: id, currentDate: currentDate)
        print(#fileID, #function, #line, fetchRequest.predicate as Any)
        do {
            let records = try context.fetch(fetchRequest)
            if let record = records.first {
                context.delete(record)
                saveContext()
            }
        } catch {
            print(#fileID, #function, #line, error)
        }
    }
    
    func countTrackerCompletedTrackers(id: UInt) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %d",
            #keyPath(TrackerRecordCoreData.idTracker),
            Int32(id) as CVarArg
        )
        print(#fileID, #function, #line, fetchRequest.predicate as Any)
        do {
            let records = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, records.count as Any)
            return records.count
        } catch {
            print(#fileID, #function, #line)
            return 0
        }
    }
    
    func containTrackerCompletedTrackers(currentDate: Date, id: UInt) -> Bool {
        let fetchRequest = getFetchRequest(id: id, currentDate: currentDate)
        print(#fileID, #function, #line, fetchRequest.predicate as Any)
        do {
            let records = try context.fetch(fetchRequest)
            return !records.isEmpty
        } catch {
            print(#fileID, #function, #line, error)
            return false
        }
    }
    
    // MARK: - Private Methods
    private func getFetchRequest(id: UInt, currentDate: Date) -> NSFetchRequest<TrackerRecordCoreData> {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "%K == %d AND %K == %@",
            #keyPath(TrackerRecordCoreData.idTracker),
            Int32(id) as CVarArg,
            #keyPath(TrackerRecordCoreData.date),
            currentDate as CVarArg
        )
        return fetchRequest
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
