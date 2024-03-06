
import UIKit

final class EditCategoriesViewController: UIViewController {
    
    private var categories: [String] = ["Важное", "Срочное", "Неотложенное"]
    
    var editText:((String) -> ())?
    
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
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Добавление категории"
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
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationItem.hidesBackButton = true
        addSCategorySubViews()
        setupConstraints()
    }
    
    private func addSCategorySubViews(){
        view.addSubview(titleLabel)
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
            
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc private func createCategoryButtonTapped() {
        guard let text = newCategoryTextField.text else {return}
        if text.isEmpty{} else {editText?(text)}
        dismiss(animated: true)
    }
}
