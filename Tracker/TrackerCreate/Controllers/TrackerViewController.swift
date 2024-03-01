
import UIKit

final class TrackerViewController: UIViewController {
    
    private var categories: [TrackerCategory] {
        categoriesStore.fetchAllTrackers()
    }
    private let categoriesStore = TrackerStore()
    private var activeCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private var typeFilter: TypeFilter = .textAndDatePickerTrackers
    
    private enum TypeFilter{
        case allTrackers
        case todayTrackers
        case completedTrackers
        case uncompletedTrackers
        case textAndDatePickerTrackers
    }
    
    private var currentDate: Date = Date() {
        didSet {
            updateActiveCategories()
        }
    }
    private var dateSelected: Date?
    private var addTrackerButton = UIBarButtonItem()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .ypBGDatePickerDay
        datePicker.layer.cornerRadius = 8
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.calendar.firstWeekday = 1
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    private lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackerCellsView.self, forCellWithReuseIdentifier: "\(TrackerCellsView.self)")
        collectionView.backgroundColor = .ypWhite
        return collectionView
    }()
    
    private lazy var placeHoldersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "TrackerPlaceHolderImage")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var placeHoldersLabel: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Добавьте первый трекер"
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium12
        label.textAlignment = .center
        label.isHidden = true
        return label
    } ()
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .ypBackgroundDay
        textField.textColor = .ypBlack
        textField.font = .hugeTitleMedium17
        textField.layer.cornerRadius = 16
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        let attributesPlaceHolder = NSAttributedString(string: "Поиск", attributes: attributes)
        
        textField.attributedPlaceholder = attributesPlaceHolder
        textField.delegate = self
        return textField
    }()
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.textColor = .ypWhite
        button.backgroundColor = .ypBlue
        button.titleLabel?.font = .hugeTitleMedium17
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addSubViews()
        trackerHeaderAdd()
        setupTrackersConstraint()
        reloadPlaceHolders()
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        updateActiveCategories()
        trackersCollectionView.reloadData()
        categoriesStore.delegate = self
    }
    //MARK: Functions
    @objc private func dateChanged(sender: UIDatePicker) {
        typeFilter = .textAndDatePickerTrackers
        updateActiveCategories()
    }
    @objc private func filterButtonTapped(){
        let createVC = FilterViewController()
        createVC.selectedFilter = {[weak self] selectedFilter in
            switch selectedFilter{
            case "Все трекеры":
                print("Все трекеры")
                self?.typeFilter = .allTrackers
                
            case "Трекеры на сегодня":
                print("Трекеры на сегодня")
                self?.typeFilter = .todayTrackers
                
            case "Завершенные":
                print("Завершенные")
                self?.typeFilter = .completedTrackers
                
            case "Не завершенные":
                print("Не завершенные")
                self?.typeFilter = .uncompletedTrackers
                
            default:
                self?.typeFilter = .allTrackers
            }
            self?.updateActiveCategories()
        }
        let navController = UINavigationController(rootViewController: createVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func setupNavBar(){
        addTrackerButton = UIBarButtonItem(image: UIImage(named: "AddTrackerButton"), style: .plain, target: self, action: #selector(addTapped))
        addTrackerButton.tintColor = UIColor.ypBlack
        view.backgroundColor = .ypWhite
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem?.customView?.backgroundColor = .ypWhite
    }
    
    @objc func addTapped(){
        let trackerTypeSelectionVC = TrackerTypeSelectionViewController()
        trackerTypeSelectionVC.delegate = self
        let navController = UINavigationController(rootViewController: trackerTypeSelectionVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func reloadPlaceHolders() {
        if searchTextField.text?.isEmpty == false {
            if activeCategories.isEmpty {
                placeHoldersLabel.isHidden = false
                placeHoldersLabel.text = "Ничего не найдено"
                placeHoldersImageView.isHidden = false
                placeHoldersImageView.image = UIImage(named: "SearchResultPlaceHolderImage")
                trackersCollectionView.isHidden = true
            } else {
                placeHoldersLabel.isHidden = true
                placeHoldersImageView.isHidden = true
                trackersCollectionView.isHidden = false
            }
        } else {
            if activeCategories.isEmpty {
                placeHoldersLabel.isHidden = false
                placeHoldersLabel.text = "Что будем отслеживать?"
                placeHoldersImageView.isHidden = false
                placeHoldersImageView.image = UIImage(named: "PlaceHolder")
                trackersCollectionView.isHidden = true
            } else {
                placeHoldersLabel.isHidden = true
                placeHoldersImageView.isHidden = true
                trackersCollectionView.isHidden = false
            }
        }
    }
    
    func updateActiveCategories() {
        switch typeFilter {
        case .textAndDatePickerTrackers : activeCategories = textAndDataFilter(categories: self.categories)
            
        case .allTrackers:
            activeCategories = textAndDataFilter(categories: self.categories)
        case .todayTrackers:
            datePicker.date = Date()
            activeCategories = textAndDataFilter(categories: self.categories)
            
        case .completedTrackers:
            activeCategories = completeTrackerFilter(categories: self.categories)
        case .uncompletedTrackers:
            activeCategories = uncompletedTrackerFilter(categories: self.categories)
        }
        trackersCollectionView.reloadData()
        reloadPlaceHolders()
    }
    
    private func textAndDataFilter(categories: [TrackerCategory]) -> [TrackerCategory] {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchTextField.text ?? "").lowercased()
        
        return categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.title.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains{ weekDay in
                    weekDay.rawValue == filterWeekDay} == true
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty{ return nil }
            
            return TrackerCategory(
                title: category.title, trackers: trackers)
        }
    }
    
    private func completeTrackerFilter(categories: [TrackerCategory]) -> [TrackerCategory]{
        let completeTrackers = self.completedTrackers.filter({ $0.date == datePicker.date}).map({$0.id})
        var filteredCompleteTrackers: [TrackerCategory] = []
        for category in categories {
            let filteredTrackers = category.trackers.filter({ tracker in
                completeTrackers.contains(where: {$0 == tracker.id})})
            if filteredTrackers.isEmpty{
                continue
            } else {
                filteredCompleteTrackers.append(.init(title: category.title, trackers: filteredTrackers))
            }
        }
        return filteredCompleteTrackers
    }
    private func uncompletedTrackerFilter(categories: [TrackerCategory]) -> [TrackerCategory] {
        let completeTrackers = self.completedTrackers.map({$0.id})
        let categoriesOnSelectedWeekDay = categoriesOnSelectedWeekDay(categories: categories)
        var filteredUncompletedTrackers: [TrackerCategory] = []
        for category in categoriesOnSelectedWeekDay {
            let filteredTrackers = category.trackers.filter({ tracker in
                !completeTrackers.contains(where: {$0 == tracker.id})})
            if filteredTrackers.isEmpty{
                continue
            } else {
                filteredUncompletedTrackers.append(.init(title: category.title, trackers: filteredTrackers))
            }
        }
        return filteredUncompletedTrackers
    }
    private func categoriesOnSelectedWeekDay(categories: [TrackerCategory]) -> [TrackerCategory] {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: datePicker.date)
        
        return categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let dateCondition = tracker.schedule.contains{ weekDay in
                    weekDay.rawValue == filterWeekDay
                }
                return dateCondition
            }
            
            if trackers.isEmpty{ return nil }
            
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    }
    
    private func addSubViews() {
        view.addSubview(searchTextField)
        view.addSubview(placeHoldersLabel)
        view.addSubview(placeHoldersImageView)
        view.addSubview(trackersCollectionView)
        view.addSubview(filterButton)
    }
    
    private func trackerHeaderAdd(){
        trackersCollectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerHeaderView")
    }
    
    private func setupTrackersConstraint() {
        NSLayoutConstraint.activate([
            placeHoldersImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            placeHoldersImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330),
            placeHoldersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHoldersImageView.widthAnchor.constraint(equalToConstant: 80),
            placeHoldersImageView.heightAnchor.constraint(equalToConstant: 80),
            
            placeHoldersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 490),
            placeHoldersLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304),
            placeHoldersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHoldersLabel.widthAnchor.constraint(equalToConstant: 343),
            placeHoldersLabel.heightAnchor.constraint(equalToConstant: 18),
            
            trackersCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 236),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
}
//MARK: UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return activeCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = activeCategories[section].trackers.count
        return trackers
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackerHeaderView", for: indexPath) as? TrackerHeaderView else {return UICollectionReusableView()}
        headerView.titleLabel.text = activeCategories[indexPath.section].title
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TrackerCellsView.self)", for: indexPath) as? TrackerCellsView else{return UICollectionViewCell()}
        
        let cellData = activeCategories
        let currentTracker = cellData[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        
        let isCompletedToday = isTrackerCompletedToday(id: currentTracker.id)
        let completedDays = completedTrackers.filter{
            $0.id == currentTracker.id}.count
        cell.configure(with: currentTracker, isCompletedToday: isCompletedToday, indexPath: indexPath, completedDays: completedDays)
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool{
        completedTrackers.contains{ trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
    }
}
//MARK: UICollectionViewDelegate
extension TrackerViewController: TrackerCellDelegate{
    func completedTracker(id: UUID, indexPath: IndexPath) {
        if currentDate + 3600 >= datePicker.date{
            let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
            completedTrackers.append(trackerRecord)
            trackersCollectionView.reloadItems(at:[ indexPath] )
        }else { return }
    }
    
    func uncompletedTracker(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll{ trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
        trackersCollectionView.reloadItems(at:[ indexPath] )
    }
}
//MARK: TrackerCreationDelegate
extension TrackerViewController: TrackerCreationDelegate {
    func creatingANewTracker(tracker: Tracker, category: String) {
        categoriesStore.creatingANewTracker(tracker, to: category)
        updateActiveCategories()
        trackersCollectionView.reloadData()
        reloadPlaceHolders()
        dismiss(animated: true)
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 41) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 28, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

//MARK: UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        typeFilter = .textAndDatePickerTrackers
        updateActiveCategories()
        return true
    }
}

//MARK: TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate{
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        trackersCollectionView.reloadData()
        reloadPlaceHolders()
    }
}
