
import UIKit

protocol ScheduleSelectionDelegate: AnyObject {
    func didSelectSchedule(_ selectedSchedule: [Schedule])
}

final class ScheduleSelectionViewController: UIViewController {
    
    var selectedSchedule: [Schedule] = []
    private var selectedDays: [Schedule] = []
    weak var delegate: ScheduleSelectionDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.01))
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleCell")
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.frame = CGRect(x: 0, y: 0, width: 149, height: 22)
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium16
        label.textAlignment = .center
        return label
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitialToggleStates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        addScheduleSubViews()
        setupConstraints()
    }
    
    private func addScheduleSubViews(){
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(readyButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 375),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 49),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setInitialToggleStates() {
        for day in selectedSchedule {
            if let index = Schedule.allCases.firstIndex(of: day) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell {
                    cell.scheduleSwitch.isOn = true
                }
            }
        }
    }
    
    @objc private func doneButtonTapped() {
            delegate?.didSelectSchedule(selectedDays)
            navigationController?.popViewController(animated: true)
        }
}

//MARK: TableView Delegate&DataSource

extension ScheduleSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleTableViewCell
        
        let day: Schedule
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            day = .sunday
        } else {
            day = Schedule(rawValue: indexPath.row + 2)!
        }
        
        cell.textLabel?.text = day.fullDaysOfWeek()
        cell.selectionStyle = .none
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 375)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        cell.scheduleSwitchAction = { [weak self] isOn in
            guard let self = self else { return }
            
            if isOn {
                self.selectedDays.append(day)
            } else {
                if let index = self.selectedDays.firstIndex(of: day) {
                    self.selectedDays.remove(at: index)
                }
            }
            print("Selected days after toggling: \(self.selectedDays)")
        }
        
        return cell
    }
}
