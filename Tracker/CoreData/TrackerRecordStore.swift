

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

        do {
            try context.save()
            print("рекорд трекера сохранен")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
        
    func deleteTrackerRecordCoreData(for trackerRecord: TrackerRecord) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerRecord.id as CVarArg)

        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
                print("рекорд трекера удален")
            }
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}


