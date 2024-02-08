
import UIKit



final class TrackerViewController: UIViewController {
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Домашний уют",
            trackers: [
                Tracker(
                    title: "Поливать растения",
                    color: .ypGreen,
                    emoji: "❤️",
                    schedule: [.monday, .tuesday, .friday]),
            ]),
        TrackerCategory(
            title: "Радостные мелочи",
            trackers: [
                Tracker(
                    title: "Кошка заслонила камеру на созвоне",
                    color: .orange,
                    emoji: "😻",
                    schedule: [.sunday]),
                Tracker(
                    title: "Бабушка прислала открытку в вотсапе",
                    color: .ypRed,
                    emoji: "🌺",
                    schedule: [.monday, .sunday,])
            ]),
    ]
    private var activeCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private var currentDate: Date = Date() {
        didSet {
            updateActiveCategories()
        }
    }
    private var addTrackerButton = UIBarButtonItem()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
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
        label.frame = CGRect(x: 0, y: 0, width: 343, height: 18)
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
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
//        setupSearchController()
        addSubViews()
        trackerHeaderAdd()
        setupTrackersConstraint()
        reloadPlaceHolders()
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        updateActiveCategories()
        trackersCollectionView.reloadData()
    }
    //MARK: Functions
    @objc private func dateChanged(sender: UIDatePicker) {
       updateActiveCategories()
    }
    
    private func setupNavBar(){
        addTrackerButton = UIBarButtonItem(image: UIImage(named: "AddTrackerButton"), style: .plain, target: self, action: #selector(addTapped))
        addTrackerButton.tintColor = UIColor.ypBlack
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc func addTapped(){
        let trackerTypeSelectionVC = TrackerTypeSelectionViewController()
        trackerTypeSelectionVC.delegate = self
        let navController = UINavigationController(rootViewController: trackerTypeSelectionVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func reloadPlaceHolders() {
        if activeCategories.isEmpty {
            placeHoldersLabel.isHidden = false
            placeHoldersImageView.isHidden = false
            trackersCollectionView.isHidden = true
        } else {
            if !categories.isEmpty{
                placeHoldersLabel.isHidden = false
                placeHoldersLabel.text = "Ничего не найдено"
                placeHoldersImageView.isHidden = false
                placeHoldersImageView.image = UIImage(named: "SearchResultPlaceHolderImage")
                trackersCollectionView.isHidden = true
            } else {
                placeHoldersLabel.isHidden = true
                placeHoldersLabel.isHidden = true
                trackersCollectionView.isHidden = false
            }
        }}
    
    func updateActiveCategories() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchTextField.text ?? "").lowercased()
        
        activeCategories = categories.compactMap { category in
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
        trackersCollectionView.reloadData()
        reloadPlaceHolders()
    }

    private func getDayAddition(_ day: Int) -> String {

        let preLastDigit = day % 100 / 10;

        if (preLastDigit == 1) {
            return "\(day) дней";
        }

        switch (day % 10) {
            case 1:
                return "\(day) день";
            case 2,3,4:
                return "\(day) дня";
            default:
                return "\(day) дней";
        }
    }
    
    private func addSubViews() {
//        view.addSubview(searchController.searchBar)
        view.addSubview(searchTextField)
        view.addSubview(placeHoldersLabel)
        view.addSubview(placeHoldersImageView)
        view.addSubview(trackersCollectionView)
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
            searchTextField.heightAnchor.constraint(equalToConstant: 36)
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
                
        cell.delegate = self
        cell.indexPath = indexPath
        
        let currentTracker = activeCategories[indexPath.section].trackers[indexPath.row]
        cell.trackerCellView.backgroundColor = currentTracker.color
        cell.emojiLabel.text = currentTracker.emoji
        cell.trackerLabel.text = currentTracker.title
        cell.trackerButton.backgroundColor = currentTracker.color
        
        let trackerRecords = completedTrackers.filter { $0.id == currentTracker.id }
        let daysCount = trackerRecords.count
        cell.countDaysLabel.text = getDayAddition(daysCount)
        
        let trackerIsCompleted = trackerRecords.contains { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
        
        if trackerIsCompleted {
            cell.trackerCompleted = true
            cell.trackerButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.trackerButton.backgroundColor = currentTracker.color?.withAlphaComponent(0.3)
        } else {
            cell.trackerCompleted = false
            cell.trackerButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.trackerButton.backgroundColor = currentTracker.color
        }
        return cell
    }
}
//MARK: UICollectionViewDelegate
extension TrackerViewController: TrackerCellDelegate{
    func trackerButtonTapped(at indexPath: IndexPath) {
        let selectedCategory = activeCategories[indexPath.section]
        let selectedTracker = selectedCategory.trackers[indexPath.row]
        
        let today = Date()
        if currentDate > today {return}
        
        _ = completedTrackers.filter { $0.id == selectedTracker.id }
        
        if let existingRecord = completedTrackers.first(where: { $0.id == selectedTracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate) }) {
            if let index = completedTrackers.firstIndex(where: { $0.id == existingRecord.id }) {
                completedTrackers.remove(at: index)
                if let cell = trackersCollectionView.cellForItem(at: indexPath) as? TrackerCellsView {
                    cell.trackerCompleted = false
                    cell.trackerButton.setImage(UIImage(systemName: "plus"), for: .normal)
                    cell.trackerButton.backgroundColor = selectedTracker.color
                }
            }
        } else {
            let newRecord = TrackerRecord(id: selectedTracker.id, date: currentDate)
            completedTrackers.append(newRecord)
            
            if let cell = trackersCollectionView.cellForItem(at: indexPath) as? TrackerCellsView {
                cell.trackerCompleted = true
                cell.trackerButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                cell.trackerButton.backgroundColor = selectedTracker.color?.withAlphaComponent(0.3)
            }
        }
        
        let cell = trackersCollectionView.cellForItem(at: indexPath) as! TrackerCellsView
                let daysCount = completedTrackers.filter { $0.id == selectedTracker.id }.count
                cell.countDaysLabel.text = getDayAddition(daysCount)

                trackersCollectionView.reloadData()
    }
}
//MARK: TrackerCreationDelegate
extension TrackerViewController: TrackerCreationDelegate {
    func creatingANewTracker(_ tracker: Tracker, isEvent: Bool) {
        let newCategory = TrackerCategory(
            title: "Важное",
            trackers: [tracker]
        )
        
        var updatedCategories = categories.map { category -> TrackerCategory in
            if category.title == newCategory.title {
                return TrackerCategory(title: category.title, trackers: category.trackers + [tracker])
            } else {
                return category
            }
        }
        
        if !updatedCategories.contains(where: { $0.title == newCategory.title }) {
            updatedCategories.append(newCategory)
        }

        categories = updatedCategories
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
