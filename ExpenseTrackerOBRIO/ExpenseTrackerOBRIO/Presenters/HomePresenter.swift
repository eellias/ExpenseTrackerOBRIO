//
//  FirstPresenter.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 18.03.2024.
//

import Foundation

protocol HomePresenterProtocol {
    var view: HomeViewProtocol? { get set }
    var transactions: [Transaction] { get set }
    var groupedTransactions: [Date:[Transaction]] { get }
    func viewDidLoad()
    func updateCurrency(currency: BitcoinCurrency)
    func updateBalance()
    func restoreCurrency()
    func addBitcoinsToBalance(amount: Double)
    func loadMoreTransactions(page: Int, pageSize: Int)
    func updateTransactions()
}

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    let mockCurrency: BitcoinCurrency
    
    let storageManager = StorageManager.shared
    
    var transactions: [Transaction] = []
    
    var groupedTransactions: [Date:[Transaction]] {
        Dictionary(grouping: transactions) { transaction in
            if let date = transaction.transactionDate {
                return Calendar.current.startOfDay(for: date)
            } else {
                return Date()
            }
        }
    }
    
    init() {
        self.mockCurrency = BitcoinCurrency(time: Time(updatedISO: Date().format("yyyy-MM-dd'T'HH:mm:ssZ")), bpi: Bpi(usd: USD(symbol: "&#36;", rate: "68,108.108", rate_float: 68108.1081)))
    }
    
    func viewDidLoad() {
        updateBalance()
        updateTransactions()
    }
    
    func updateCurrency(currency: BitcoinCurrency) {
        view?.updateCurrency(currency: currency)
        UserDefaults.standard.setValue(Date(), forKey: "lastBitcoinCurrencyUpdateDate")
        self.encodeCurrencyData(currencyToStore: currency)
        updateLastUpdated()
    }
    
    func restoreCurrency() {
        view?.updateCurrency(currency: self.decodeCurrencyData() ?? mockCurrency)
        updateLastUpdated()
    }
    
    func updateLastUpdated() {
        view?.updateLastUpdated(date: UserDefaults.standard.object(forKey: "lastBitcoinCurrencyUpdateDate") as? Date ?? Date())
    }
    
    func updateBalance() {
        let balance = storageManager.fetchBalance()
        view?.updateBalance(balance: balance?.balance ?? 0.0)
    }
    
    func addBitcoinsToBalance(amount: Double) {
        storageManager.addBitcoins(amount: amount)
        storageManager.addTransaction(type: false, amount: amount, category: nil)
        self.updateBalance()
        self.updateTransactions()
    }
    
    func updateTransactions() {
        self.transactions = storageManager.fetchTransactions(page: 1, pageSize: 20)
        view?.reloadTransactions()
    }
    
    func loadMoreTransactions(page: Int, pageSize: Int) {
        let newTransactions = storageManager.fetchTransactions(page: page, pageSize: pageSize)
        if !newTransactions.isEmpty {
            self.transactions.append(contentsOf: newTransactions)
            view?.updateTransactions(newTransactions: newTransactions)
        }
    }
}

extension HomePresenter {
    func encodeCurrencyData(currencyToStore: BitcoinCurrency) {
        do {
            let currency = currencyToStore
            let encoder = JSONEncoder()
            let data = try encoder.encode(currency)
            UserDefaults.standard.set(data, forKey: "lastBitcoinCurrency")
        } catch {
            
        }
    }
    
    func decodeCurrencyData() -> BitcoinCurrency? {
        guard let data = UserDefaults.standard.data(forKey: "lastBitcoinCurrency") else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let currency = try decoder.decode(BitcoinCurrency.self, from: data)
            return currency
        } catch {
            return nil
        }
    }
}
