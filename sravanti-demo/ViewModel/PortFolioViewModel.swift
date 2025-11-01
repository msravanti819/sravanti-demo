//
//  PortFolioViewModel.swift
//  sravanti-demo
//
//  Created by Sravanti on 01/11/25.
//

import Foundation

final class PortFolioViewModel {
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Data
    private(set) var holdings: [Holding] = []
    private(set) var portfolioSummary: PortfolioSummary?
    
    
    // MARK: - Callbacks for View
    var onHoldingsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Performing dependency injenction
    init(networkService: NetworkServiceProtocol = PortFolioNetworkManager.shared) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    func fetchHoldings() async {
        await MainActor.run { onLoading?(true) }
        
        do {
            let fetchedHoldings = try await networkService.fecthData(Constants.API.portFolioUrl)
            holdings = fetchedHoldings
            portfolioSummary = calculatePortfolioSummary(from: holdings)
            debugPrint("Holdings = ", holdings.count)
            
            await MainActor.run {
                onLoading?(false)
                onHoldingsUpdated?()
            }
        } catch {
            debugPrint("Error fetching holdings: \(error)")
            await MainActor.run {
                onLoading?(false)
                onError?("Failed to load holdings. Please try again.")
            }
        }
    }
    
    func numberOfHoldings() -> Int {
        return holdings.count
    }
    
    func holding(at index: Int) -> Holding? {
        guard index >= 0 && index < holdings.count else { return nil }
        return holdings[index]
    }
    
    // MARK: - Port Folio Calculation
    
    private func calculatePortfolioSummary(from holdings: [Holding]) -> PortfolioSummary {
        let currentValue = holdings.reduce(0.0) { $0 + ($1.ltp * Double($1.quantity)) }
        let totalInvestment = holdings.reduce(0.0) { $0 + ($1.avgPrice * Double($1.quantity)) }
        let totalPnL = currentValue - totalInvestment
        let todaysPnL = holdings.reduce(0.0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
        
        return PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPnL: totalPnL,
            todaysPnL: todaysPnL
        )
    }
}
