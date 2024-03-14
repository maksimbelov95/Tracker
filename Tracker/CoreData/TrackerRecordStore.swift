

import UIKit
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) {
        
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = trackerRecord.date
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.daysSince1970 = trackerRecord.daysSince1970
        do {
            try context.save()
            print("Saving TrackerRecord for \(trackerRecord.id) on \(trackerRecord.date)")
        } catch {
            print("Error saving TrackerRecord: \(error)")
        }
    }
    func deleteTrackerRecordForStatistic(for trackerRecord: TrackerRecord) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerRecord.id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }
    
    func deleteTrackerRecordCoreData(for trackerRecord: TrackerRecord) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND daysSince1970 == %id", trackerRecord.id as CVarArg, trackerRecord.daysSince1970 as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }
    func fetchAllRecordCoreData() -> [TrackerRecord] {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap{ result in
                guard let id = result.id, let date = result.date  else {return nil}
                let daysSince1970 = result.daysSince1970
                return TrackerRecord(id: id, date: date, daysSince1970: daysSince1970)
            }
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
            return []
        }
    }
    func fetchAllRecordCoreDataCount() -> Int {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.count

        } catch {
            print("Error fetching TrackerCoreData: \(error)")
            return 0
        }
    }
    func deleteTrackerRecord() {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }
}
