//
//  TransactionAddingPresenterProtocol.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation

protocol TransactionAddingPresenterProtocol {
    var view: TransactionAddingViewProtocol? { get set }
    var coordinator: AppCoordinator? { get set }
    var balance: Double { get set }
    
    func addTransaction(amount: Double, category: String)
    func didSelectTransactionCategory(_ category: String)
}
