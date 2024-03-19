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
    
    func addTransaction(amount: Double, category: String)
    func didSelectTransactionCategory(_ category: String)
}

class TransactionAddingPresenter: TransactionAddingPresenterProtocol {
    weak var view: TransactionAddingViewProtocol?
    weak var coordinator: AppCoordinator?
    
    let storageManager = StorageManager.shared
    
    func addTransaction(amount: Double, category: String) {
        storageManager.addTransaction(type: true, amount: amount, category: category)
        storageManager.addBitcoins(amount: amount)
        coordinator?.navigationController.popViewController(animated: true)
    }
    
    func didSelectTransactionCategory(_ category: String) {
        view?.didSelectTransactionCategory(category)
    }
}
