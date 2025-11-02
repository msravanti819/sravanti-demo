//
//  HoldingModelTests.swift
//  sravanti-demoTests
//
//  Created by Sravanti on 02/11/25.
//

import XCTest
@testable import sravanti_demo

final class HoldingModelTests: XCTestCase {
    
    // MARK: - Holding Model Tests
    
    func testHolding_Initialization() {
        // Given & When
        let holding = Holding(
            symbol: "AAPL",
            quantity: 10,
            ltp: 150.0,
            avgPrice: 140.0,
            close: 155.0
        )
        
        // Then
        XCTAssertEqual(holding.symbol, "AAPL")
        XCTAssertEqual(holding.quantity, 10)
        XCTAssertEqual(holding.ltp, 150.0)
        XCTAssertEqual(holding.avgPrice, 140.0)
        XCTAssertEqual(holding.close, 155.0)
    }
    
    func testHolding_DecodingFromJSON() throws {
        // Given
        let jsonString = """
        {
            "symbol": "TCS",
            "quantity": 5,
            "ltp": 3500.0,
            "avgPrice": 3600.0,
            "close": 3550.0
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let holding = try JSONDecoder().decode(Holding.self, from: jsonData)
        
        // Then
        XCTAssertEqual(holding.symbol, "TCS")
        XCTAssertEqual(holding.quantity, 5)
        XCTAssertEqual(holding.ltp, 3500.0)
        XCTAssertEqual(holding.avgPrice, 3600.0)
        XCTAssertEqual(holding.close, 3550.0)
    }
    
    func testUserHoldingsResponse_DecodingFromJSON() throws {
        // Given
        let jsonString = """
        {
            "data": {
                "userHolding": [
                    {
                        "symbol": "TCS",
                        "quantity": 10,
                        "ltp": 3500.0,
                        "avgPrice": 3600.0,
                        "close": 3550.0
                    },
                    {
                        "symbol": "INFY",
                        "quantity": 5,
                        "ltp": 1500.0,
                        "avgPrice": 1400.0,
                        "close": 1520.0
                    }
                ]
            }
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(UserHoldingsResponse.self, from: jsonData)
        
        // Then
        XCTAssertEqual(response.data.userHolding.count, 2)
        XCTAssertEqual(response.data.userHolding[0].symbol, "TCS")
        XCTAssertEqual(response.data.userHolding[1].symbol, "INFY")
    }
    
    func testUserHoldingsResponse_EmptyHoldings() throws {
        // Given
        let jsonString = """
        {
            "data": {
                "userHolding": []
            }
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(UserHoldingsResponse.self, from: jsonData)
        
        // Then
        XCTAssertEqual(response.data.userHolding.count, 0)
    }
    
    func testHolding_DecodingWithMissingFields() {
        // Given
        let jsonString = """
        {
            "symbol": "TCS",
            "quantity": 5
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // When & Then
        XCTAssertThrowsError(try JSONDecoder().decode(Holding.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testHolding_DecodingWithWrongTypes() {
        // Given
        let jsonString = """
        {
            "symbol": 123,
            "quantity": "invalid",
            "ltp": 3500.0,
            "avgPrice": 3600.0,
            "close": 3550.0
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // When & Then
        XCTAssertThrowsError(try JSONDecoder().decode(Holding.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}

