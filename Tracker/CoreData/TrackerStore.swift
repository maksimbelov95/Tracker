
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
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title , ascending: true)]
        
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
        } catch {
            assertionFailure("Ошибка инициализации TrackerStore: \(error)")
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
            color: color.toUIColor(),
            emoji: emoji,
            schedule: schedule.split(separator: ",").compactMap { sch in
                guard let int = Int(sch) else { return nil }
                return Schedule(rawValue: int)
            },
            isPinned: trackerCoreData.isPinned
        )
    }
    
    func fetchAllTrackers() -> [TrackerCategory] {
        guard let sections = fetchedResultsController.fetchedObjects else { return [] }
        
        var allCategories = [TrackerCategory]()
        
        for section in sections {
            if let trackersSet = section.trackers, let categoryTitle = section.title {
                let tracersArray = (trackersSet.allObjects as! [TrackerCoreData]).compactMap { trackerCoreData in
                    return tracker(from:trackerCoreData)
                }
                let category = TrackerCategory(title: categoryTitle, trackers: tracersArray)
                allCategories.append(category)
            }
        }
        
        return allCategories
    }
    
    func creatingANewTracker(_ tracker: Tracker, to category: String) {
        let trackerCoreData = TrackerCoreData(context: context)
        let categoryCoreData = self.fetchedResultsController.fetchedObjects?.first(where: {elem in
            elem.title == category
        })
        saveTracker(trackerCoreData, with: tracker, category: categoryCoreData)
        
        if let categoryCoreData = categoryCoreData {
            categoryCoreData.addToTrackers(trackerCoreData)
        }
        do {
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }
    
    private func saveTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker, category: TrackerCategoryCoreData?) {
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color?.toHexString() ?? "#FF0000"
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule.compactMap( { String($0.rawValue) } ).joined(separator: ",")
        category?.addToTrackers(trackerCoreData)
    }
    func updateTracker(for tracker: Tracker){
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            guard let trackerCoreData = try context.fetch(fetchRequest).first else {return}
            trackerCoreData.title = tracker.title
            trackerCoreData.color = tracker.color?.toHexString() ?? "#FF0000"
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule.compactMap( { String($0.rawValue) } ).joined(separator: ",")
            
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }
    
    
    func deleteTrackerCoreData(for tracker: Tracker) {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            guard let result = try context.fetch(fetchRequest).first else {return}
            context.delete(result)
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
    }

    func toggleTracker(for tracker: Tracker){
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            guard let result = try context.fetch(fetchRequest).first else {return}
            result.isPinned.toggle()
            try context.save()
        } catch {
            print("Error fetching TrackerCoreData: \(error)")
        }
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



