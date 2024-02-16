import UIKit

final class TrackerTypeSelectionViewController: UIViewController {
    var selectedCategory: String?
    weak var delegate: TrackerCreationDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium16
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()

    private let eventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.textColor = .ypWhite
        button.titleLabel?.font = .hugeTitleMedium16
        button.frame = CGRect(x: 0, y: 0, width: 335, height: 60)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(eventButton)
        setupConstraints()
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 149),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),

            habitButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 281),

            eventButton.widthAnchor.constraint(equalToConstant: 335),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
        ])
    }
//MARK: ButtonActions
    @objc func habitButtonTapped() {
        selectedCategory = "Привычка"
        let createHabitVC = CreateTrackerViewController(state: .habit)
        createHabitVC.delegate = delegate 
        let navController = UINavigationController(rootViewController: createHabitVC)
        present(navController, animated: true, completion: nil)
    }

    @objc func eventButtonTapped() {
        selectedCategory = "Нерегулярное событие"
        let createEventVC = CreateTrackerViewController(state: .irregularEvent)
        createEventVC.delegate = delegate
        let navController = UINavigationController(rootViewController: createEventVC)
        present(navController, animated: true, completion: nil)
    }
}

