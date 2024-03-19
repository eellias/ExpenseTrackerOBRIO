//
//  AppCoordinator.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 18.03.2024.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        let homePresenter = HomePresenter()
        homePresenter.view = homeViewController
        homePresenter.coordinator = self
        homeViewController.presenter = homePresenter
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func navigateToTransactionAddingScreen() {
        let transactionAddingViewController = TransactionAddingViewController()
        let transactionAddingPresenter = TransactionAddingPresenter()
        transactionAddingPresenter.view = transactionAddingViewController
        transactionAddingPresenter.coordinator = self
        transactionAddingViewController.presenter = transactionAddingPresenter
        navigationController.pushViewController(transactionAddingViewController, animated: true)
    }
}
