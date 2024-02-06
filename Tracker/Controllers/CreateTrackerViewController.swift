
import UIKit

protocol TrackerCreationDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, isEvent: Bool)
}

class CreateTrackerViewController: UIViewController {
    
    var schedule: [Schedule] = []
    
    weak var delegate: TrackerCreationDelegate?
    
    private let maxCharacterCount = 38
    private let state: ViewState
    private var habitDesc: String?
    private var eventDesc: String?

    
    enum ViewState {
        case habit
        case irregularEvent
        
        var title: String {
            switch self{
            case .habit : return "Создание привычки"
            case .irregularEvent : return "Нерегулярное событие"
            }
        }
        
        var heightCell: CGFloat {
            return 75
        }
        
    }
    var heightTable: CGFloat {
        return self.state.heightCell * CGFloat(cellData.count)
    }
    
    var cellData: [TrackerCategoryCells]  {
        switch self.state {
        case .habit :
            return [.init(title: "Категория", description: self.habitDesc), .init(title: "Расписание", description: self.eventDesc)]
        case .irregularEvent :
            return [.init(title: "Категория", description: self.habitDesc)]
        }
    }
    struct TrackerCategoryCells {
        let title: String
        var description: String?
    }
    
    init(state: ViewState) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .ypWhite
        return scrollView
    }()
 
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 24
        stackView.backgroundColor = .ypWhite
        return stackView
    }()
    private lazy var stackViewButton: UIStackView = {
        let stackViewButton = UIStackView()
        stackViewButton.translatesAutoresizingMaskIntoConstraints = false
        stackViewButton.axis = .horizontal
        stackViewButton.distribution = .fillProportionally
        stackViewButton.alignment = .fill
        stackViewButton.spacing = 8
        stackViewButton.backgroundColor = .ypWhite
        stackViewButton.addArrangedSubview(cancelButton)
        stackViewButton.addArrangedSubview(createButton)
        return stackViewButton
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .ypBackgroundDay
        textField.font = .hugeTitleMedium17
        textField.textColor = .ypBlack
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 0
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var symbolsLimitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.font =  .hugeTitleMedium17
        label.textColor = .ypRed
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let cornerRadius: CGFloat = 16.0
        tableView.layer.cornerRadius = cornerRadius
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let emojiCollectionView = EmojiCollectionViewController(frame: .zero, collectionViewLayout: layout)
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        emojiCollectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"TrackerHeaderView" )
        emojiCollectionView.backgroundColor = .ypWhite
        emojiCollectionView.delegate = emojiCollectionView
        emojiCollectionView.dataSource = emojiCollectionView
        return emojiCollectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let colorCollectionView = ColorCollectionViewController(frame: .zero, collectionViewLayout: layout)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        colorCollectionView.backgroundColor = .ypWhite
        colorCollectionView.delegate = colorCollectionView
        colorCollectionView.dataSource = colorCollectionView
        return colorCollectionView
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        button.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor.ypRed, for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = .ypGray
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        addViewToStackView()
        setUpConstraints()
        title = state.title
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    private func settingsNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.ypBlack,
            .font: UIFont.hugeTitleMedium16
        ]
    }
    private func emojiHeaderAdd(){
        emojiCollectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmojiAndColorsHeaderView")
    }
    private func colorsHeaderAdd(){
        colorCollectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmojiAndColorsHeaderView")
    }
    private func addSubViews() {
        settingsNavigationBar()
        addViewToStackView()
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        emojiHeaderAdd()
        colorsHeaderAdd()
    }

    private func addViewToStackView(){
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(symbolsLimitLabel)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(emojiCollectionView)
        stackView.addArrangedSubview(colorCollectionView)
        stackView.addArrangedSubview(stackViewButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            symbolsLimitLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.heightAnchor.constraint(equalToConstant: heightTable),
            
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 228),
            
            colorCollectionView.heightAnchor.constraint(equalToConstant: 228),
            
            stackViewButton.heightAnchor.constraint(equalToConstant: 60),    
        ])
    }
    
    private func scheduleDescription() -> String {
        let allDaysOfWeek = Schedule.allCases

        if Set(schedule) == Set(allDaysOfWeek) {
            return "Каждый День"
        } else if !schedule.isEmpty {
            return schedule.map { $0.shortDaysOfWeek() }.joined(separator: ", ")
        }

        return ""
    }
    
    @objc private func textFieldDidChange() {
        guard let text = nameTextField.text else { return }

        clearButton.isHidden = text.isEmpty
        symbolsLimitLabel.isHidden = text.count <= maxCharacterCount
    }
}

extension CreateTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let cellData = cellData[indexPath.row]

        cell.configure(title: cellData.title, description: cellData.description)

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let scheduleSelectionVC = ScheduleSelectionViewController()
            scheduleSelectionVC.selectedSchedule = self.schedule
            scheduleSelectionVC.delegate = self
            self.navigationController?.pushViewController(scheduleSelectionVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return state.heightCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == cellData.count - 1
        let defaultInset = tableView.separatorInset
        
        if isLastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = defaultInset
        }
    }
    
}

extension CreateTrackerViewController: ScheduleSelectionDelegate{
    func didSelectSchedule(_ selectedSchedule: [Schedule]) {
        self.schedule = selectedSchedule
        print("Выбранные дни обновлены: \(selectedSchedule)")
        tableView.reloadData()
//        updateCreateButtonState()
    }
}