
import UIKit

final class CategoryViewController: UIViewController {
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private var lastSelectedIndexPath: IndexPath?
    
    var selectedCategory: ((String) -> ())?
    var viewModel: CategorySelectionViewModelProtocol
    
    init(viewModel: CategorySelectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var savedCategory: String?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypGray
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
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.titleLabel?.font = .hugeTitleMedium16
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var placeHoldersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "PlaceHolder")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var placeHoldersLabel: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = """
           Привычки и события можно  объединить по смыслу
           """
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium12
        label.textAlignment = .center
        label.isHidden = true
        return label
    } ()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCategoryTitles()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationItem.hidesBackButton = true
        addSCategorySubViews()
        setupConstraints()
        viewModel.categoryTitlesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func addSCategorySubViews(){
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
        view.addSubview(placeHoldersLabel)
        view.addSubview(placeHoldersImageView)
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
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
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
        ])
    }
    private func reloadPlaceHolders() {
        if viewModel.categoryTitles.isEmpty{
            placeHoldersImageView.isHidden = false
            placeHoldersLabel.isHidden = false
            tableView.isHidden = true
        } else {
            placeHoldersImageView.isHidden = true
            placeHoldersLabel.isHidden = true
            tableView.isHidden = false
        }
        
    }
    @objc private func addCategoryButtonTapped() {
        let createVC = EditCategoriesViewController()
        createVC.titleLabel.text = "Редактирование категории"
        createVC.editText = { [weak self] text in
            self?.trackerCategoryStore.addNewTrackerCategory(title: text, trackers: [])
            self?.viewModel.fetchCategoryTitles()
        }
        let navController = UINavigationController(rootViewController: createVC)
        present(navController, animated: true, completion: nil)
    }
}

//MARK: Category TableView DelegateAndDataSource

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.categoryTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        cell.titleCategory.text = viewModel.categoryTitles[indexPath.row]
   
        cell.selectedCategoryImage.isHidden = cell.titleCategory.text != savedCategory
        
        cell.delegate = self
        cell.indexPath = indexPath
        reloadPlaceHolders()
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categoryTitles[indexPath.row]
        selectedCategory?(category)
        lastSelectedIndexPath = indexPath
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == viewModel.categoryTitles.count - 1
        let defaultInset = tableView.separatorInset
        var corners: UIRectCorner = []
        if viewModel.categoryTitles.count == 1 {
            corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        } else {
            if indexPath.row == 0 {
                corners = [.topLeft, .topRight]
            } else if indexPath.row == viewModel.categoryTitles.count - 1 {
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

//MARK: CategoryCoreDataAndCellDelegate
extension CategoryViewController: CategoryTableViewCellDelegate{
    
    func edit(indexPath: IndexPath) {
        let createVC = EditCategoriesViewController()
        createVC.titleLabel.text = "Редактирование категории"
        createVC.editText = { [weak self] text in
            if let titleCategory = self?.viewModel.categoryTitles[indexPath.row] {
                self?.trackerCategoryStore.updateTrackerCategoryCoreData(for: titleCategory, newTitle: text)
            }
            self?.viewModel.fetchCategoryTitles()
            self?.reloadPlaceHolders()
        }
        let navController = UINavigationController(rootViewController: createVC)
        present(navController, animated: true, completion: nil)
    }
    
    func delete(indexPath: IndexPath) {
        let deleteTitleCategory = self.viewModel.categoryTitles[indexPath.row]
        self.trackerCategoryStore.deleteTrackerCategoryCoreData(for: deleteTitleCategory)
        self.viewModel.fetchCategoryTitles()
        reloadPlaceHolders()
    }
}

