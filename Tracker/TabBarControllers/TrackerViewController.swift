
import UIKit



final class TrackerViewController: UIViewController {
    private var addTrackerButton = UIBarButtonItem()
    private var searchController: UISearchController = {
            let search = UISearchController(searchResultsController: nil)
            search.searchBar.placeholder = "Поиск"
            search.obscuresBackgroundDuringPresentation  = false
            return search
        }()
    private  var datePicker: UIDatePicker = {
            let dataPicker = UIDatePicker()
            dataPicker.datePickerMode = .date
            return dataPicker
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    private func setupNavBar(){
        addTrackerButton = UIBarButtonItem(image: UIImage(named: "AddTracker"), style: .plain, target: self, action: #selector(addTapped))
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc func addTapped(){
        print("tapped")
        
    }
    }
