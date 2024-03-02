
import CoreData
import UIKit


final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    
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
                    let tracersArray = trackersSet.allObjects as? [Tracker] ?? []
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
    
    func addNewTrackerCategory(title: String) {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = title
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
 
}
