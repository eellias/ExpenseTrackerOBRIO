//
//  HomePresenterProtocol.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 19.03.2024.
//

import Foundation

protocol HomePresenterProtocol {
    var view: HomeViewProtocol? { get set }
    var coordinator: AppCoordinator? { get set }
    var transactions: [Transaction] { get set }
    var groupedTransactions: [Date:[Transaction]] { get }
    func viewDidLoad()
    func updateCurrency(currency: BitcoinCurrency)
    func updateBalance()
    func restoreCurrency()
    func addBitcoinsToBalance(amount: Double)
    func loadMoreTransactions(page: Int, pageSize: Int)
    func updateTransactions()
    func addTransaction()
    func presentAddBitcoinsPopup()
}
