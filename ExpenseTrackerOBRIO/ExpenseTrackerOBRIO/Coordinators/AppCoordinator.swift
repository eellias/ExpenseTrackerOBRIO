//
//  AppCoordinator.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 18.03.2024.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func navigateToTransactionAddingScreen()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        let homePresenter = HomePresenter()
        homePresenter.view = homeViewController
        homeViewController.presenter = homePresenter
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func navigateToTransactionAddingScreen() {
        let transactionAddingViewController = TransactionAddingViewController()
        let transactionAddingPresenter = TransactionAddingPresenter()
        transactionAddingPresenter.view = transactionAddingViewController
        transactionAddingViewController.presenter = transactionAddingPresenter
        transactionAddingViewController.coordinator = self
        navigationController.pushViewController(transactionAddingViewController, animated: true)
    }
}
