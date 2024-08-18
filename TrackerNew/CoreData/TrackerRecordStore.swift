//
//  TrackerRecordStore.swift
//  TrackerNew
//
//  Created by gimon on 14.07.2024.
//

import UIKit
import CoreData

// MARK: - RecordDataProviderDelegate
protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecord()
}


final class TrackerRecordStore: NSObject {
    
    // MARK: - Private Properties
    private let uiColorMarshalling = UIColorMarshalling()
    private let daysValueTransformer = DaysValueTransformer()
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    
    // MARK: - Public Properties
    let context: NSManagedObjectContext
    weak var delegate: TrackerRecordStoreDelegate?
    
    // MARK: - Initializers
    convenience override init() {
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
        guard let record = getFetchRequest(id: id, currentDate: currentDate) as? TrackerRecordCoreData else {
            print(#fileID, #function, #line, "nil")
            return nil
        }
        print(#fileID, #function, #line, "record: \(record)")
        return record
    }
    
    func deleteTrackerCompletedTrackers(currentDate: Date, id: UInt) {
        guard let record = getFetchRequest(id: id, currentDate: currentDate) as? TrackerRecordCoreData else {
            print(#fileID, #function, #line, "nil")
            return
        }
        print(#fileID, #function, #line, "record: \(record)")
        context.delete(record)
        saveContext()
    }
    
    func countTrackerCompletedTrackers(id: UInt) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = fetchedResultsController.fetchRequest
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
        guard let _ = getFetchRequest(id: id, currentDate: currentDate) else {
            print(#fileID, #function, #line, "false")
            return false
        }
        print(#fileID, #function, #line, "true")
        return true
    }
    
    func getCountRecords() -> Int {
        print(#fileID, #function, #line)
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = fetchedResultsController.fetchRequest
        do {
            let records = try context.fetch(fetchRequest)
            print(#fileID, #function, #line, "records.count")
            return records.count
        } catch {
            print(#fileID, #function, #line, "catch")
            return 0
        }
    }
    
    // MARK: - Private Methods
    private func getFetchRequest(id: UInt, currentDate: Date) -> NSFetchRequestResult? {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = fetchedResultsController.fetchRequest
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            //            format: "%K == %d AND %K == %@",
            format: "%K == %d",
            #keyPath(TrackerRecordCoreData.idTracker),
            Int32(id) as CVarArg//,
            //            #keyPath(TrackerRecordCoreData.date),
            //            currentDate as CVarArg
        )
        var record: [NSFetchRequestResult]?
        do {
            let records = try context.fetch(fetchRequest)
            record = records.filter {
                return dateIgnoreTime(date: $0.date) == dateIgnoreTime(date: currentDate)
            }
        } catch {
            return nil
        }
        guard let record else {
            return nil
        }
        if record.isEmpty {
            return nil
        }
        return record.first
    }
    
    private func dateIgnoreTime (date: Date?) -> Date? {
        guard let date else {
            return nil
        }
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let dateWithoutTime = Calendar.current.date(from: dateComponents)
        return dateWithoutTime
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
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(#fileID, #function, #line)
        delegate?.didUpdateRecord()
    }
}
