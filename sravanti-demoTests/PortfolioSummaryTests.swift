//
//  PortfolioSummaryTests.swift
//  sravanti-demoTests
//
//  Created by Sravanti on 02/11/25.
//

import XCTest
@testable import sravanti_demo

final class PortfolioSummaryTests: XCTestCase {
    
    // MARK: - PortfolioSummary Initialization Tests
    
    func testPortfolioSummary_Initialization() {
        // Given
        let currentValue = 1000.0
        let totalInvestment = 900.0
        let totalPnL = 100.0
        let todaysPnL = 50.0
        
        // When
        let summary = PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPnL: totalPnL,
            todaysPnL: todaysPnL
        )
        
        // Then
        XCTAssertEqual(summary.currentValue, currentValue)
        XCTAssertEqual(summary.totalInvestment, totalInvestment)
        XCTAssertEqual(summary.totalPnL, totalPnL)
        XCTAssertEqual(summary.todaysPnL, todaysPnL)
    }
    
    // MARK: - totalPnLPercentage Tests
    
    func testTotalPnLPercentage_PositivePercentage() {
        // Given
        let summary = PortfolioSummary(
            currentValue: 1100.0,
            totalInvestment: 1000.0,
            totalPnL: 100.0,
            todaysPnL: 50.0
        )
        
        // When
        let percentage = summary.totalPnLPercentage
        
        // Then
        XCTAssertEqual(percentage, 10.0, accuracy: 0.01) // (100 / 1000) * 100 = 10%
    }
    
    func testTotalPnLPercentage_NegativePercentage() {
        // Given
        let summary = PortfolioSummary(
            currentValue: 900.0,
            totalInvestment: 1000.0,
            totalPnL: -100.0,
            todaysPnL: -50.0
        )
        
        // When
        let percentage = summary.totalPnLPercentage
        
        // Then
        XCTAssertEqual(percentage, -10.0, accuracy: 0.01) // (-100 / 1000) * 100 = -10%
    }
    
    func testTotalPnLPercentage_ZeroInvestment() {
        // Given
        let summary = PortfolioSummary(
            currentValue: 0.0,
            totalInvestment: 0.0,
            totalPnL: 0.0,
            todaysPnL: 0.0
        )
        
        // When
        let percentage = summary.totalPnLPercentage
        
        // Then
        XCTAssertEqual(percentage, 0.0) // Should return 0 when investment is 0
    }
    
    func testTotalPnLPercentage_HighPercentage() {
        // Given
        let summary = PortfolioSummary(
            currentValue: 2000.0,
            totalInvestment: 1000.0,
            totalPnL: 1000.0,
            todaysPnL: 500.0
        )
        
        // When
        let percentage = summary.totalPnLPercentage
        
        // Then
        XCTAssertEqual(percentage, 100.0, accuracy: 0.01) // (1000 / 1000) * 100 = 100%
    }
    
    func testTotalPnLPercentage_SmallPercentage() {
        // Given
        let summary = PortfolioSummary(
            currentValue: 1001.0,
            totalInvestment: 1000.0,
            totalPnL: 1.0,
            todaysPnL: 0.5
        )
        
        // When
        let percentage = summary.totalPnLPercentage
        
        // Then
        XCTAssertEqual(percentage, 0.1, accuracy: 0.01) // (1 / 1000) * 100 = 0.1%
    }
    
    func testTotalPnLPercentage_DecimalPrecision() {
        // Given
        let summary = PortfolioSummary(
            currentValue: 1050.0,
            totalInvestment: 1000.0,
            totalPnL: 50.0,
            todaysPnL: 25.0
        )
        
        // When
        let percentage = summary.totalPnLPercentage
        
        // Then
        XCTAssertEqual(percentage, 5.0, accuracy: 0.01) // (50 / 1000) * 100 = 5%
    }
}

