
import UIKit

class TrackerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let addTrackerButton = UIBarButtonItem(image: UIImage(named: "AddTracker"), style: .plain, target: self, action: #selector(addTapped))
        view.backgroundColor = .white
        navigationController?.navigationItem.leftBarButtonItem = addTrackerButton
    }
    @objc func addTapped(){
        print("tapped")
    }
}
