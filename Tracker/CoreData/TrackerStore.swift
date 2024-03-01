
import CoreData
import UIKit

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
    let insertedSections: IndexSet
    let deletedSections: IndexSet
}

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.title , ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    weak var delegate: TrackerStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    private var insertedSections: IndexSet?
    private var deletedSections: IndexSet?
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try self.init(context: context)
        } catch let error as NSError {
            print(error.localizedDescription)
            self.init(fallbackContext: context)
        }
    }
    
    init(fallbackContext: NSManagedObjectContext) {
        self.context = fallbackContext
        super.init()
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) -> Tracker? {
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
            color: color as? UIColor,
            emoji: emoji,
            schedule: schedule as! [Schedule])
    }
    func fetchAllTrackers() -> [TrackerCategory] {
        guard let sections = fetchedResultsController.sections else { return [] }
        
        var allCategories = [TrackerCategory]()
        
        for section in sections {
            let categoryTitle = section.name
            let trackersInCategory = (section.objects as? [TrackerCoreData] ?? []).compactMap { tracker(from: $0) }
            
            let category = TrackerCategory(title: categoryTitle, trackers: trackersInCategory)
            allCategories.append(category)
        }
        
        return allCategories
    }
    
    func creatingANewTracker(_ tracker: Tracker, to category: String) {
        let trackerCoreData = TrackerCoreData(context: context)
        let categoryCoreData = getTrackerCategoryCoreData(by: category)
        updateTracker(trackerCoreData, with: tracker, category: categoryCoreData)
        
        if let categoryCoreData = categoryCoreData {
            categoryCoreData.addToTrackers(trackerCoreData)
        }
        do {
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }
    
    func updateTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker, category: TrackerCategoryCoreData?) {
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.category = category
    }
    
    func getTrackerCategoryCoreData(by title: String) -> TrackerCategoryCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    func deleteTrackerCoreData(for tracker: Tracker) {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

//MARK: UICollectionViewDataSource

extension TrackerStore {
    
    func tracker(for indexPath: IndexPath, currentDate: Date) -> Tracker? {
        guard let sectionInfo = fetchedResultsController.sections?[indexPath.section],
              let trackerCoreData = sectionInfo.objects?[indexPath.row] as? TrackerCoreData,
              let schedule = trackerCoreData.schedule as? [Schedule],
              let selectedDay = getDayOfWeek(currentDate) else {
            return nil
        }
        
        if schedule.contains(selectedDay) {
            return try? tracker(from: trackerCoreData)
        } else {
            return nil
        }
    }
    
    func getDayOfWeek(_ date: Date) -> Schedule? {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        return Schedule(rawValue: dayOfWeek)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerStoreUpdate.Move>()
        insertedSections = IndexSet()
        deletedSections = IndexSet ()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes ?? IndexSet(),
                deletedIndexes: deletedIndexes ?? IndexSet(),
                updatedIndexes: updatedIndexes ?? IndexSet(),
                movedIndexes: movedIndexes ?? Set<TrackerStoreUpdate.Move>(),
                insertedSections: insertedSections ?? IndexSet(),
                deletedSections: deletedSections ?? IndexSet()
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
        insertedSections = nil
        deletedSections = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            insertedSections?.insert(sectionIndex)
        case .delete:
            deletedSections?.insert(sectionIndex)
        default:
            break
        }
    }
}



