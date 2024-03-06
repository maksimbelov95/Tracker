
import Foundation

protocol CategorySelectionViewModelProtocol {
    var categoryTitles: [String] { get }
    var categoryTitlesUpdated: (() -> Void)? { get set }
    var сategoryChoice: ((String) -> Void)? { get set }
    
    var delegate: CategorySelectionDelegate? { get set }

    func fetchCategoryTitles()
    func selectCategory(at index: Int)
}

protocol CategorySelectionDelegate: AnyObject {
    func categorySelected(_ category: String)
}

final class CategorySelectionViewModel: CategorySelectionViewModelProtocol {
    
    private let categoryStore: TrackerCategoryStore
    
    weak var delegate: CategorySelectionDelegate?
    
    var categoryTitles: [String] = [] {
        didSet {
            categoryTitlesUpdated?()
        }
    }
    var categoryTitlesUpdated: (() -> Void)?
    var сategoryChoice: ((String) -> Void)?
        
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
    }

    func fetchCategoryTitles() {
        categoryTitles = categoryStore.getAllTrackersCategory().compactMap{ $0.title }
    }
    
    func selectCategory(at index: Int) {
        let selectedCategory = categoryTitles[index]
        delegate?.categorySelected(selectedCategory)
        сategoryChoice?(selectedCategory)
    }
}
