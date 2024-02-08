
import UIKit

protocol ScheduleSelectionDelegate: AnyObject {
    func selectedSchedule(_ selectedSchedule: [Schedule])
}

final class ScheduleSelectionViewController: UIViewController {
    
    let weekDays:[Schedule] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    var selectedDays = Set<Schedule>()
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
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setInitialToggleStates() {
        for day in selectedDays {
            if let index = Schedule.allCases.firstIndex(of: day) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell {
                    cell.scheduleSwitch.isOn = true
                }
            }
        }
    }
    
    @objc private func doneButtonTapped() {
        let selectedDays = self.selectedDays.map({$0}).sorted(by: {$0.rawValue < $1.rawValue})
        delegate?.selectedSchedule(selectedDays)
            navigationController?.popViewController(animated: true)
        }
}

//MARK: Schedule TableView DelegateAndDataSource

extension ScheduleSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleTableViewCell
        
        let day: Schedule
        day = weekDays[indexPath.row]
        cell.titleSchedule.text = day.fullDaysOfWeek()
        cell.selectionStyle = .none
        cell.scheduleSwitchAction = { [weak self] switchOn in
            guard let self = self else { return }
            
            if switchOn {
                self.selectedDays.insert(day)
            } else {
                if let index = self.selectedDays.firstIndex(of: day) {
                    self.selectedDays.remove(at: index)
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == weekDays.count - 1
        let defaultInset = tableView.separatorInset

        if isLastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
