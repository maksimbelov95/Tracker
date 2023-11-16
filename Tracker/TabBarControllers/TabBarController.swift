
import Foundation
import UIKit

class TabBarController: UITabBarController{
    let trackerView = TrackerViewController()
    let statisticView = StatisticViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setupTabBar()
    }
    private func generateTabBar(){
        let trackerNav = UINavigationController(rootViewController: trackerView)
        let statisticNav = UINavigationController(rootViewController: statisticView)
        viewControllers = [
            generateVC(viewController: trackerNav, title: "Трекеры", image: UIImage(named:"TabBarTracker")),
            generateVC(viewController: statisticNav, title: "Статистика", image: UIImage(named: "TabBarStatistic"))]
    }
    private func generateVC(viewController: UINavigationController, title: String, image: UIImage?) -> UINavigationController{
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
        
    }
    private func setupTabBar(){
        tabBar.backgroundColor = .white
    }
    private func setupNavControllers(){
    }
}
