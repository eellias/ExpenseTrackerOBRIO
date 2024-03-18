//
//  BitcoinCurrency.swift
//  ExpenseTrackerOBRIO
//
//  Created by eellias on 18.03.2024.
//

import Foundation

struct BitcoinCurrency: Codable {
    let time: Time
    let bpi: Bpi
}

struct Time: Codable {
    let updatedISO: String
}

struct Bpi: Codable {
    let usd: USD

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct USD: Codable {
    let symbol: String
    let rate: String
    let rate_float: Double
}
