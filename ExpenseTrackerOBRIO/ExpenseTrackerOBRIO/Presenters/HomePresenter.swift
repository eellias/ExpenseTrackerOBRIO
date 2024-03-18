//
//  FirstPresenter.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 18.03.2024.
//

import Foundation

protocol HomePresenterProtocol {
    var view: HomeViewProtocol? { get set }
    func viewDidLoad()
    func updateCurrency(currency: BitcoinCurrency)
    func restoreCurrency()
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    let mockCurrency: BitcoinCurrency
    
    init() {
        self.mockCurrency = BitcoinCurrency(time: Time(updatedISO: Date().format("yyyy-MM-dd'T'HH:mm:ssZ")), bpi: Bpi(usd: USD(symbol: "&#36;", rate: "68,108.108", rate_float: 68108.1081)))
    }
    
    func viewDidLoad() {
        
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
