
import UIKit

class StatisticViewController: UIViewController {
    
    let trackerRecordStore = TrackerRecordStore()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .ypWhite
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 12
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: "StatisticTableViewCell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupNavBar()
        addSubViews()
        setupConstraints()
    }
    
    private func addSubViews(){
        view.addSubview(tableView)
    }
    
    private func setupNavBar(){
        view.backgroundColor = .ypWhite
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "statistics".localized()
        navigationItem.titleView?.backgroundColor = .ypBlack
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

//MARK: Statistic TableView DelegateAndDataSource
extension StatisticViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticTableViewCell", for: indexPath) as! StatisticTableViewCell
        cell.statisticTitle.text = "\(trackerRecordStore.fetchAllRecordCoreDataCount())"
        cell.statisticDescription.text = "Трекеров завершено"
        cell.backgroundColor = .ypBlack
        cell.selectionStyle = .none
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.bounds
        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.orange.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor,
            UIColor.purple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        cell.gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == 1
        let defaultInset = tableView.separatorInset
        var corners: UIRectCorner = []
        corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        
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
