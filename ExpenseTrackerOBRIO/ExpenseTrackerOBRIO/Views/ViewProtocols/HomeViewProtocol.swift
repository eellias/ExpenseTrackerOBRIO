//
//  HomeViewProtocol.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func updateCurrency(currency: BitcoinCurrency)
    func updateLastUpdated(date: Date)
    func updateBalance(balance: Double)
    func presentAlert()
    func reloadTransactions()
    func updateTransactions(newTransactions: [Transaction])
}
