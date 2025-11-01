//
//  UserHoldingModel.swift
//  sravanti-demo
//
//  Created by Sravanti on 01/11/25.
//

import Foundation

struct UserHoldingModel: Decodable {
    let data: DataResponse
}

// MARK: - DataClass
struct DataResponse: Decodable {
    let userHolding: [UserHolding]
}

// MARK: - UserHolding
struct UserHolding: Decodable {
    let symbol: String
    let quantity: Int
    let ltp, avgPrice, close: Double
}

struct UserHoldingsResponse: Decodable {
    let data: UserHoldingsData
}

struct UserHoldingsData: Decodable {
    let userHolding: [Holding]
}

struct Holding: Decodable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}

struct PortfolioSummary {
    let currentValue: Double
    let totalInvestment: Double
    let totalPnL: Double
    let todaysPnL: Double
    
    var totalPnLPercentage: Double {
        guard totalInvestment > 0 else { return 0 }
        return (totalPnL / totalInvestment) * 100
    }
}
