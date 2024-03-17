
import UIKit

final class TrackerViewController: UIViewController {
    
    private var categories: [TrackerCategory] {
            let allCategories = categoriesStore.fetchAllTrackers()
            let deletePinnedCategories = deletePinnedTrackers(categories: allCategories)
      if let pinnedCategories = searchPinnedTrackers(categories: allCategories) {
       return [pinnedCategories] + deletePinnedCategories
      } else {
       return deletePinnedCategories
      }
        }
    private let trackerRecordStore = TrackerRecordStore()
    private let categoriesStore = TrackerStore()
    private var activeCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] {
        trackerRecordStore.fetchAllRecordCoreData()
    }
    
    private var typeFilter: TypeFilter = .allTrackers
    
    private var savedFilter: String = "Все трекеры"
    
    private enum TypeFilter{
        case allTrackers
        case todayTrackers
        case completedTrackers
        case uncompletedTrackers
    }
    
    private var currentDate: Date = Date() {
        didSet {
            updateActiveCategories()
        }
    }
    private var dateSelected: Date?
    private var addTrackerButton = UIBarButtonItem()
    private let yandexMetric: YandexMetrics = YandexMetrics()
    
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
        let attributesPlaceHolder = NSAttributedString(string: "search".localized(), attributes: attributes)
        
        textField.attributedPlaceholder = attributesPlaceHolder
        textField.delegate = self
        return textField
    }()
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("filters".localized(), for: .normal)
        button.titleLabel?.textColor = .ypWhite
        button.backgroundColor = .ypBlue
        button.titleLabel?.font = .hugeTitleMedium17
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        yandexMetric.openMainScreen()
    }
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
//        trackerRecordStore.deleteTrackerRecord()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        yandexMetric.closedMainScreen()
    }
    //MARK: Functions
    @objc private func dateChanged(sender: UIDatePicker) {
        updateActiveCategories()
    }
    @objc private func filterButtonTapped(){
        yandexMetric.clickedFilterButton()
        let createVC = FilterViewController()
        createVC.savedFilter = self.savedFilter
        createVC.selectedFilter = {[weak self] selectedFilter in
            self?.savedFilter = selectedFilter
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
        navigationItem.title = "trackers".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem?.customView?.backgroundColor = .ypWhite
    }
    
    @objc func addTapped(){
        yandexMetric.clickedTrackerCreateButton()
        let trackerTypeSelectionVC = TrackerTypeSelectionViewController()
        trackerTypeSelectionVC.delegate = self
        let navController = UINavigationController(rootViewController: trackerTypeSelectionVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func reloadPlaceHolders() {
        if categories.flatMap({$0.trackers}).isEmpty {
            placeHoldersLabel.isHidden = false
            placeHoldersLabel.text = "what_we_will_track".localized()
            placeHoldersImageView.isHidden = false
            placeHoldersImageView.image = UIImage(named: "PlaceHolder")
            trackersCollectionView.isHidden = true
        } else {
            if activeCategories.flatMap({$0.trackers}).isEmpty {
                placeHoldersLabel.isHidden = false
                placeHoldersLabel.text = "nothing_found".localized()
                placeHoldersImageView.isHidden = false
                placeHoldersImageView.image = UIImage(named: "SearchResultPlaceHolderImage")
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
            
        case .allTrackers:
            activeCategories = textAndDataFilter(categories: self.categories)
        case .todayTrackers:
            datePicker.date = Date()
            activeCategories = textAndDataFilter(categories: self.categories)
            
        case .completedTrackers:
            let completedTracker = textAndDataFilter(categories: self.categories)
            activeCategories = completeTrackerFilter(categories: completedTracker)
        case .uncompletedTrackers:
            let unCompletedTracker = textAndDataFilter(categories: self.categories)
            activeCategories = uncompletedTrackerFilter(categories: unCompletedTracker)
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
        let daysDatePicker = daysSince1970Recalculate(date: datePicker.date)
        let completeTrackers = self.completedTrackers.filter({tracker in
            let daysTracker1970 = daysSince1970Recalculate(date: tracker.date)
            return daysTracker1970 == daysDatePicker}).map({$0.id})
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
        let daysDatePicker = daysSince1970Recalculate(date: datePicker.date)
        let completeTrackers = self.completedTrackers.filter({tracker in
            let daysTracker1970 = daysSince1970Recalculate(date: tracker.date)
            return daysTracker1970 == daysDatePicker}).map({$0.id})
        var filteredUncompletedTrackers: [TrackerCategory] = []
        for category in categories {
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
    
    private func searchPinnedTrackers(categories: [TrackerCategory]) -> TrackerCategory? {
            let pinnedTrackers = categories.map({$0.trackers}).flatMap({$0}).filter({$0.isPinned})
      if pinnedTrackers.isEmpty { return nil }
            let pinnedCategory = TrackerCategory(title: "Закрепленные", trackers: pinnedTrackers)
            return pinnedCategory
        }
    
    private func deletePinnedTrackers(categories: [TrackerCategory]) -> [TrackerCategory]{
        var filteredCategories: [TrackerCategory] = []
        for category in categories {
            let notPinnedTrackers = category.trackers.filter({ !$0.isPinned })
            filteredCategories.append(TrackerCategory(title: category.title, trackers: notPinnedTrackers))
        }
        return filteredCategories
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
            
            trackersCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: filterButton.topAnchor),
            
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
        cell.pinImage.isHidden = !currentTracker.isPinned
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
        yandexMetric.reportTrackerCompleteButton()
        let daysCurrentDate = daysSince1970Recalculate(date: currentDate)
        let daysDatePicker = daysSince1970Recalculate(date: datePicker.date)
        if daysCurrentDate >= daysDatePicker {
            let trackerRecord = TrackerRecord(id: id, date: datePicker.date, daysSince1970: daysSince1970Recalculate(date: datePicker.date))
            trackerRecordStore.addNewTrackerRecord(trackerRecord)
            trackersCollectionView.reloadItems(at:[indexPath])
            updateActiveCategories()
            print(trackerRecord.daysSince1970)
        }else { return }
        
    }
    
    func uncompletedTracker(id: UUID, indexPath: IndexPath) {
        yandexMetric.reportTrackerUnCompleteButton()
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date, daysSince1970: daysSince1970Recalculate(date: datePicker.date) )
        trackerRecordStore.deleteTrackerRecordCoreData(for: trackerRecord)
        trackersCollectionView.reloadItems(at:[indexPath])
        updateActiveCategories()
        print(trackerRecord.daysSince1970)
    }
    func daysSince1970Recalculate(date: Date) -> Int64{
        let secondsInDay: TimeInterval = 60 * 60 * 24
        return Int64(date.timeIntervalSince1970/secondsInDay)
    }
    
}
//MARK: TrackerCreationDelegate
extension TrackerViewController: TrackerCreationDelegate {
    func creatingANewTracker(createTrackerType: CreateTrackerType) {
        switch createTrackerType {
        case .create(let tracker, let category) :
            categoriesStore.creatingANewTracker(tracker, to: category)
        case .update(let tracker, let category) :
            categoriesStore.deleteTrackerCoreData(for: tracker)
            categoriesStore.creatingANewTracker(tracker, to: category)
        }
        
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

//MARK: ContextMenuCщllectionView
extension TrackerViewController {
    func edit(indexPath: IndexPath) {
        yandexMetric.reportTrackerEdit()
        let currentTracker = activeCategories[indexPath.section].trackers[indexPath.row]
        let completedDays = completedTrackers.filter{$0.id == currentTracker.id}.count
        let createEditTrackerVC = CreateTrackerViewController(state: .trackerEdit(
            tracker: activeCategories[indexPath.section].trackers[indexPath.row],
            trackerCategory: activeCategories[indexPath.section], countDays: completedDays))
        createEditTrackerVC.delegate = self
        let navController = UINavigationController(rootViewController: createEditTrackerVC)
        present(navController, animated: true, completion: nil)
    }
    
    func delete(indexPath: IndexPath) {
        yandexMetric.reportTrackerDelete()
        let tracker = activeCategories[indexPath.section].trackers[indexPath.row]
        
        let alertController = UIAlertController(title: "", message: "Уверены что хотите удалить трекер?", preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.categoriesStore.deleteTrackerCoreData(for: tracker)
            let trackerRecord = TrackerRecord(id: tracker.id, date: self.datePicker.date, daysSince1970: self.daysSince1970Recalculate(date: self.datePicker.date) )
            self.trackerRecordStore.deleteTrackerRecordForStatistic(for: trackerRecord)
            self.updateActiveCategories()
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true)
    }
}

extension TrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCellsView else { return nil }
        return UITargetedPreview(view: cell.trackerCellView)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        
        return UIContextMenuConfiguration(actionProvider:{ suggestedActions in
            let tracker = self.activeCategories[indexPath.section].trackers[indexPath.row]
            let title = tracker.isPinned ? "Открепить" : "Закрепить"
            let action = UIAction(title: title) { [weak self] action in
                guard let self else {return}
                self.categoriesStore.toggleTracker(for: tracker)
                self.updateActiveCategories()
            }
            
            let edit = UIAction(title: "Редактировать") { [weak self] action in
                guard let self else {return}
                self.edit(indexPath: indexPath)
                
            }
            
            let delete = UIAction(title: "Удалить", attributes: .destructive) { [weak self] action in
                guard let self else {return}
                self.delete(indexPath: indexPath)
            }
            return UIMenu(children: [action, edit, delete])
        })
    }
}
