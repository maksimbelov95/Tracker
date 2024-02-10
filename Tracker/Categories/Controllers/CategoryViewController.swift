
import UIKit

final class CategoryViewController: UIViewController {
    
    private var categories: [String] = ["Важное", "Срочное", "Неотложенное"]
    
    var selectedCategory: ((String) -> ())?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.frame = CGRect(x: 0, y: 0, width: 149, height: 22)
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium17
        label.textAlignment = .center
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
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
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
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
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc private func addCategoryButtonTapped() {
        let createVC = EditCategoriesViewController()
        createVC.titleLabel.text = "Редактирование категории"
        createVC.editText = { [weak self] text in
            self?.categories.append(text)
            self?.tableView.reloadData()
        }
        let navController = UINavigationController(rootViewController: createVC)
        present(navController, animated: true, completion: nil)
        }
}

//MARK: Category TableView DelegateAndDataSource

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
       
        cell.titleCategory.text = categories[indexPath.row]
        cell.selectionStyle = .none
        
        cell.delegate = self
        cell.indexPath = indexPath


        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        selectedCategory?(category)
        print("\(category)")
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == categories.count - 1
        let defaultInset = tableView.separatorInset
        var corners: UIRectCorner = []
        if categories.count == 1 {
           corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
          } else {
           if indexPath.row == 0 {
            corners = [.topLeft, .topRight]
           } else if indexPath.row == categories.count - 1 {
            corners = [.bottomLeft, .bottomRight]
           }
          }
          let radius: CGFloat = 16
          let path = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
          let mask = CAShapeLayer()
          mask.path = path.cgPath
          cell.layer.mask = mask
        
        if isLastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = defaultInset
        }
    }
}
extension CategoryViewController: CategoryTableViewCellDelegate{
    func edit(indexPath: IndexPath) {
        let createVC = EditCategoriesViewController()
        createVC.titleLabel.text = "Редактирование категории"
        createVC.editText = { [weak self] text in
            self?.categories[indexPath.row] = text
            self?.tableView.reloadData()
        }
        let navController = UINavigationController(rootViewController: createVC)
        present(navController, animated: true, completion: nil)
    }
    
    func delete(indexPath: IndexPath) {
        categories.remove(at: indexPath.row)
        tableView.reloadData()
    }
}
