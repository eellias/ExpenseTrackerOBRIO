//
//  SceneDelegate.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 17.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        coordinator = AppCoordinator(navigationController: navigationController)
        coordinator?.start()
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
        let lastUpdateDate = UserDefaults.standard.object(forKey: "lastBitcoinCurrencyUpdateDate") as? Date ?? Date().addingTimeInterval(-3600)
        let elapsedTime = Date().timeIntervalSince(lastUpdateDate)
        let homeVC = self.coordinator?.navigationController.viewControllers.first as? HomeViewController
        if elapsedTime >= 3600 {
            let apiService = APIService(urlString: "https://api.coindesk.com/v1/bpi/currentprice.json")
            
            if let homeVC = homeVC {
                homeVC.presenter.restoreCurrency()
            }
            
            DispatchQueue.main.async {
                apiService.getJSON { (result: Result<BitcoinCurrency, APIError>) in
                    switch result {
                    case .success(let currency):
                        DispatchQueue.main.async {
                            if let homeVC = homeVC {
                                homeVC.presenter.updateCurrency(currency: currency)
                            }
                        }
                    case .failure(_):
                        print("Failure")
                        DispatchQueue.main.async {
                            if let homeVC = homeVC {
                                homeVC.presenter.restoreCurrency()
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            homeVC?.presentAlert()
                        }
                    }
                }
            }
        } else {
            if let homeVC = homeVC {
                homeVC.presenter.restoreCurrency()
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        StorageManager.shared.saveContext()
    }


}

