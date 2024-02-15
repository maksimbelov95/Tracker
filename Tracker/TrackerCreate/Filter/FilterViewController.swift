

import UIKit

final class FilterViewController: UIViewController {
    
    private var filterCategories: [String] = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    var selectedFilter: ((String) -> ())?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Фильтры"
        label.frame = CGRect(x: 0, y: 0, width: 149, height: 22)
        label.textColor = .ypBlack
        label.font = .hugeTitleMedium17
        label.textAlignment = .center
        return label
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
        ])
    }
}

//MARK: Filter TableView DelegateAndDataSource

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
       
        cell.titleCategory.text = filterCategories[indexPath.row]
        cell.selectionStyle = .none
        cell.indexPath = indexPath

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = filterCategories[indexPath.row]
        selectedFilter?(category)
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == filterCategories.count - 1
        let defaultInset = tableView.separatorInset
        var corners: UIRectCorner = []
        if filterCategories.count == 1 {
           corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
          } else {
           if indexPath.row == 0 {
            corners = [.topLeft, .topRight]
           } else if indexPath.row == filterCategories.count - 1 {
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

