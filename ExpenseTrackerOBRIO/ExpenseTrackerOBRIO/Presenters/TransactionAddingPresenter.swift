//
//  TransactionAddingPresenter.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation

protocol TransactionAddingPresenterProtocol {
    var view: TransactionAddingViewProtocol? { get set }
    var coordinator: AppCoordinator? { get set }
    
    func addTransaction()
    func didSelectTransactionCategory(_ category: String)
}

class TransactionAddingPresenter: TransactionAddingPresenterProtocol {
    weak var view: TransactionAddingViewProtocol?
    weak var coordinator: AppCoordinator?
    
    func addTransaction() {
        coordinator?.navigationController.popViewController(animated: true)
    }
    
    func didSelectTransactionCategory(_ category: String) {
        view?.didSelectTransactionCategory(category)
    }
}
