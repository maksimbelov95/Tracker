
import CoreData
import UIKit


final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    
    private let trackerRecordStore = TrackerRecordStore()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAllTrackersCategory() -> [TrackerCategory] {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        var allCategories = [TrackerCategory]()
        do {
            let results = try context.fetch(fetchRequest)
            for section in results {
                if let trackersSet = section.trackers, let categoryTitle = section.title {
                    let tracersArray = (trackersSet.allObjects as! [TrackerCoreData]).compactMap { trackerCoreData in
                        return tracker(from:trackerCoreData)
                    }
                    let category = TrackerCategory(title: categoryTitle, trackers: tracersArray)
                    allCategories.append(category)
                }
            }
            return allCategories
        } catch {
            print("Error fetching TrackerCategoryCoreData: \(error)")
            return []
        }
    }
    
    func getTrackerCategoryCoreData(by title: String) -> TrackerCategoryCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching TrackerCategoryCoreData: \(error)")
            return nil
        }
    }
    
    func addNewTrackerCategory(title: String, trackers: [Tracker]) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = title
        
        trackers.forEach { tracker in
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.title = tracker.title
            trackerCoreData.color = tracker.color?.toHexString() ?? "#FF0000"
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule.compactMap( { String($0.rawValue) } ).joined(separator: ",")
            
            categoryCoreData.addToTrackers(trackerCoreData)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func deleteTrackerCategoryCoreData(for title: String) {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                if let trackersSet = result.trackers {
                    let tracersArray = (trackersSet.allObjects as! [TrackerCoreData]).compactMap { trackerCoreData in
                        return tracker(from:trackerCoreData)
                    }
                    for tracker in tracersArray {
                        trackerRecordStore.deleteTrackerRecordForCategories(for: tracker.id)
                    }
                }
                context.delete(result)
            }
            
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }
    
    func updateTrackerCategoryCoreData(for title: String, newTitle: String) {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            results.first?.title = newTitle
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }
   private func tracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id else {
            return nil
        }
        guard let title = trackerCoreData.title else {
            return nil
        }
        guard let color = trackerCoreData.color else {
            return nil
        }
        guard let emoji = trackerCoreData.emoji else {
            return nil
        }
        guard let schedule = trackerCoreData.schedule else {
            return nil
        }
        return Tracker(
            id: id,
            title: title,
            color: color.toUIColor(),
            emoji: emoji,
            schedule: schedule.split(separator: ",").compactMap { sch in
                guard let int = Int(sch) else { return nil }
                return Schedule(rawValue: int)
            },
            isPinned: trackerCoreData.isPinned
        )
    }
    
}
