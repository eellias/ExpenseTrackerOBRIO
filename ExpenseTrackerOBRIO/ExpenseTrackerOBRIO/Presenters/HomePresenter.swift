//
//  FirstPresenter.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 18.03.2024.
//

import Foundation

protocol HomePresenterProtocol {
    var view: HomeViewProtocol? { get set }
    func updateCurrency(currency: BitcoinCurrency?, isFailed: Bool)
    func restoreCurrency()
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    let formattedDate: String
    let mockCurrency: BitcoinCurrency
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let currentDate = Date()
        self.formattedDate = dateFormatter.string(from: currentDate)
        
        self.mockCurrency = BitcoinCurrency(time: Time(updatedISO: formattedDate), bpi: Bpi(usd: USD(symbol: "&#36;", rate: "68,108.108", rate_float: 68108.1081)))
    }
    
    func updateCurrency(currency: BitcoinCurrency?, isFailed: Bool) {
        if !isFailed, let currency = currency {
            view?.updateCurrency(currency: currency)
            UserDefaults.standard.setValue(Date(), forKey: "lastBitcoinCurrencyUpdateDate")
            self.encodeCurrencyData(currencyToStore: currency)
        } else {
            view?.updateCurrency(currency: self.decodeCurrencyData() ?? mockCurrency)
        }
    }
    
    func restoreCurrency() {
        view?.updateCurrency(currency: self.decodeCurrencyData() ?? mockCurrency)
    }
    
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
