
import UIKit

protocol EditCategoriesViewControllerDelegate: AnyObject {
    func category()
}

final class EditCategoriesViewController: UIViewController {

    private var categories: [String] = ["Важное", "Срочное", "Неотложенное"]

    weak var delegate: EditCategoriesViewControllerDelegate?
    
    private lazy var newCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название новой категории"
        textField.backgroundColor = .ypBackgroundDay
        textField.font = .hugeTitleMedium17
        textField.textColor = .ypBlack
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 0
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(createCategoryButtonTapped), for: .editingChanged)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.layer.cornerRadius = 16
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        tableView.rowHeight = 75
//        tableView.isScrollEnabled = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(EditCategoriesTableViewCell.self, forCellReuseIdentifier: "EditCategoriesTableViewCell")
//        return tableView
//    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Добавление категории"
        label.frame = CGRect(x: 0, y: 0, width: 149, height: 22)
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium17
        label.textAlignment = .center
        return label
    }()

    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createCategoryButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        addSCategorySubViews()
        setupConstraints()
    }

    private func addSCategorySubViews(){
        view.addSubview(titleLabel)
//        view.addSubview(tableView)
        view.addSubview(createCategoryButton)
        view.addSubview(newCategoryTextField)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 375),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            newCategoryTextField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 44),
            newCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            
            
            
//
//            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            tableView.heightAnchor.constraint(equalToConstant: 525),

            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc private func createCategoryButtonTapped() {
        }
}

//MARK: Category TableView DelegateAndDataSource

//extension EditCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.categories.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EditCategoriesTableViewCell", for: indexPath) as! EditCategoriesTableViewCell
//
//        cell.titleCategory.text = categories[indexPath.row]
//        cell.selectionStyle = .none
//
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let isLastCell = indexPath.row == categories.count - 1
//        let defaultInset = tableView.separatorInset
//
//        if isLastCell {
//            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
//        } else {
//            cell.separatorInset = defaultInset
//        }
//    }
//}
