//
//  TransactionAddingPresenter.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation

class TransactionAddingPresenter: TransactionAddingPresenterProtocol {
    weak var view: TransactionAddingViewProtocol?
    weak var coordinator: AppCoordinator?
    var balance: Double
    
    let storageManager = StorageManager.shared
    
    init() {
        print("init")
        self.balance = storageManager.fetchBalance()?.balance ?? 0.0
    }
    
    func addTransaction(amount: Double, category: String) {
        storageManager.addTransaction(type: true, amount: amount, category: category)
        storageManager.addBitcoins(amount: amount)
        coordinator?.navigationController.popViewController(animated: true)
    }
    
    func didSelectTransactionCategory(_ category: String) {
        view?.didSelectTransactionCategory(category)
    }
}
