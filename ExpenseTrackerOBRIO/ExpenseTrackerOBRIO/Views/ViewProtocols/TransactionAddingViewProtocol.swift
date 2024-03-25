//
//  TransactionAddingViewProtocol.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation

protocol TransactionAddingViewProtocol: AnyObject {
    var selectedCategory: String? { get set }
    func addTransactionTapped()
    func didSelectTransactionCategory(_ category: String)
    func updateTransactionLimits(maxAmount: Double)
}
