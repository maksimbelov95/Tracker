
import UIKit



final class TrackerViewController: UIViewController {
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Домашний уют",
            trackers: [
                Tracker(
                    name: "Поливать растения",
                    color: .ypGreen,
                    emoji: "❤️",
                    schedule: [.monday, .tuesday, .friday]),
            ]),
        TrackerCategory(
            title: "Радостные мелочи",
            trackers: [
                Tracker(
                    name: "Кошка заслонила камеру на созвоне",
                    color: .orange,
                    emoji: "😻",
                    schedule: [.sunday]),
                Tracker(
                    name: "Бабушка прислала открытку в вотсапе",
                    color: .ypRed,
                    emoji: "🌺",
                    schedule: [.sunday])
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
    private var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Поиск"
        search.obscuresBackgroundDuringPresentation  = false
        return search
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.calendar.firstWeekday = 1
        datePicker.addTarget(self, action: #selector(datePickerDayChanged), for: .valueChanged)
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
    
    private let emptyTrackersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "emptyTrackerImage")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let emptyTrackersLabel: UILabel  = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 343, height: 18)
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    } ()
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addSubViews()
        setupTrackersConstraint()
        showPlaceHolder()
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
    }
    //MARK: Function
    @objc func datePickerDayChanged(sender: UIDatePicker) {
        let selectedDate = sender.date
        let calendar = Calendar.current
        let localDate = calendar.startOfDay(for: selectedDate)
        currentDate = localDate
        
        updateActiveCategories()
        trackersCollectionView.reloadData()
    }
    
    private func setupNavBar(){
        addTrackerButton = UIBarButtonItem(image: UIImage(named: "AddTracker"), style: .plain, target: self, action: #selector(addTapped))
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    @objc func addTapped(){
        print("tapped")
    }
    private func showPlaceHolder() {
        if activeCategories.isEmpty {
            emptyTrackersLabel.isHidden = false
            emptyTrackersImageView.isHidden = false
            trackersCollectionView.isHidden = true
        } else {
            emptyTrackersLabel.isHidden = true
            emptyTrackersImageView.isHidden = true
            trackersCollectionView.isHidden = false
        }
    }
    func updateActiveCategories() {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: currentDate)
        
        if let selectedDay = Schedule(rawValue: dayOfWeek) {
            activeCategories = categories.compactMap { category in
                let filteredTrackers = category.trackers.filter { $0.schedule.contains(selectedDay) }
                return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
            print("Updated active categories: \(activeCategories)")
        } else {
            print("Не удалось определить день недели")
        }
        trackersCollectionView.reloadData()
        showPlaceHolder()
        
    }
    private func addSubViews() {
        view.addSubview(searchController.searchBar)
        view.addSubview(emptyTrackersImageView)
        view.addSubview(emptyTrackersLabel)
        view.addSubview(trackersCollectionView)
    }
    private func setupTrackersConstraint() {
        NSLayoutConstraint.activate([
            emptyTrackersImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            emptyTrackersImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330),
            emptyTrackersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackersImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyTrackersImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyTrackersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 490),
            emptyTrackersLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304),
            emptyTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackersLabel.widthAnchor.constraint(equalToConstant: 343),
            emptyTrackersLabel.heightAnchor.constraint(equalToConstant: 18),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor, constant: 10),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84)
        ])
    }
}
//MARK: UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(activeCategories.count)
        return activeCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(activeCategories[section].trackers.count)
        return activeCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TrackerCellsView.self)", for: indexPath) as? TrackerCellsView else{return UICollectionViewCell()}
                
        cell.delegate = self
        cell.indexPath = indexPath
        
        let currentTracker = activeCategories[indexPath.section].trackers[indexPath.row]
        print(currentTracker)
        cell.trackerCellView.backgroundColor = currentTracker.color
        cell.emojiLabel.text = currentTracker.emoji
        cell.trackerLabel.text = currentTracker.name
        cell.trackerButton.backgroundColor = currentTracker.color
        
        let trackerRecords = completedTrackers.filter { $0.id == currentTracker.id }
        let daysCount = trackerRecords.count
        cell.countDaysLabel.text = "дней"
        
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
