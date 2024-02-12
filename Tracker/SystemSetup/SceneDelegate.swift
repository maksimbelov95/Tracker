//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Максим белов on 13.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {return}
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = OnboardingViewController()
        window.makeKeyAndVisible()
        self.window = window
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
//
//import UIKit
//
//class FirstLaunchViewController: UIViewController {
//override func viewDidLoad() {
//super.viewDidLoad()
//// Здесь можно добавить настройки для экрана первого запуска
//view.backgroundColor = .white
//let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//label.text = "Экран первого запуска"
//label.center = view.center
//view.addSubview(label)
//}
//}
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//var window: UIWindow?
//
//func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//// Проверяем, запущено ли приложение впервые
//let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//if !launchedBefore {
//// Если приложение запущено впервые, создаем экран первого запуска и показываем его
//window = UIWindow(frame: UIScreen.main.bounds)
//window?.rootViewController = FirstLaunchViewController()
//window?.makeKeyAndVisible()
//// Устанавливаем значение, чтобы знать, что приложение уже было запущено
//UserDefaults.standard.set(true, forKey: "launchedBefore")
//} else {
//// Если приложение уже запускалось, можно перейти к основному экрану
//// Здесь можно установить ваш основной экран или перейти на другой экран
//}
//return true
//}
//}
//
//// Запуск приложения
//UIApplicationMain(
//CommandLine.argc,
//CommandLine.unsafeArgv,
//nil,
//NSStringFromClass(AppDelegate.self)
//)
