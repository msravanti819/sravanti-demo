//
//  PortFolioViewModelTests.swift
//  sravanti-demoTests
//
//  Created by Sravanti on 02/11/25.
//

import Testing
@testable import sravanti_demo

struct PortFolioViewModelTests {
    
    // MARK: - Helper Methods
    
    func createMockHoldings() -> [Holding] {
        return [
            Holding(symbol: "TCS", quantity: 10, ltp: 3500.0, avgPrice: 3600.0, close: 3550.0),
            Holding(symbol: "INFY", quantity: 5, ltp: 1500.0, avgPrice: 1400.0, close: 1520.0)
        ]
    }
    
    // MARK: - Initialization Tests
    
    @Test @MainActor
    func testInitialization_WithDefaultNetworkService() async {
        // Given & When
        let defaultViewModel = PortFolioViewModel()
        
        // Then
        #expect(defaultViewModel != nil)
    }
    
    
    // MARK: - Fetch Holdings Tests
    
    @Test @MainActor
    func testFetchHoldings_Success() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        let mockHoldings = createMockHoldings()
        mockNetworkService.mockHoldings = mockHoldings
        mockNetworkService.shouldSucceed = true
        
        var loadingStates: [Bool] = []
        var holdingsUpdatedCalled = false
        var errorCalled = false
        
        viewModel.onLoading = { isLoading in
            loadingStates.append(isLoading)
        }
        
        viewModel.onHoldingsUpdated = {
            holdingsUpdatedCalled = true
        }
        
        viewModel.onError = { _ in
            errorCalled = true
        }
        
        // When
        await viewModel.fetchHoldings()
        
        // Then
        #expect(viewModel.numberOfHoldings() == 2)
        #expect(viewModel.portfolioSummary != nil)
        #expect(holdingsUpdatedCalled == true)
        #expect(errorCalled == false)
        #expect(loadingStates == [true, false])
        
        // Verify portfolio summary calculations
        guard let summary = viewModel.portfolioSummary else {
            Issue.record("Portfolio summary should not be nil")
            return
        }
        
    }
    
    @Test @MainActor
    func testFetchHoldings_Failure() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        mockNetworkService.shouldSucceed = false
        mockNetworkService.errorToThrow = NetworkError.noData
        
        var loadingStates: [Bool] = []
        var holdingsUpdatedCalled = false
        var errorMessage: String?
        
        viewModel.onLoading = { isLoading in
            loadingStates.append(isLoading)
        }
        
        viewModel.onHoldingsUpdated = {
            holdingsUpdatedCalled = true
        }
        
        viewModel.onError = { message in
            errorMessage = message
        }
        
        // When
        await viewModel.fetchHoldings()
        
        // Then
        #expect(viewModel.numberOfHoldings() == 0)
        #expect(viewModel.portfolioSummary == nil)
        #expect(holdingsUpdatedCalled == false)
        #expect(errorMessage != nil)
        #expect(errorMessage == "Failed to load holdings. Please try again.")
        #expect(loadingStates == [true, false])
    }
    
    @Test @MainActor
    func testFetchHoldings_BadUrlError() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        mockNetworkService.errorToThrow = NetworkError.badUrl
        
        var errorMessage: String?
        viewModel.onError = { message in
            errorMessage = message
        }
        
        // When
        await viewModel.fetchHoldings()
        
        // Then
        #expect(errorMessage != nil)
        #expect(errorMessage == "Failed to load holdings. Please try again.")
    }
    
    // MARK: - Holdings Access Tests
    
    @Test @MainActor
    func testNumberOfHoldings_Empty() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        
        // Then
        #expect(viewModel.numberOfHoldings() == 0)
    }
    
    @Test @MainActor
    func testNumberOfHoldings_WithHoldings() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        let mockHoldings = createMockHoldings()
        mockNetworkService.mockHoldings = mockHoldings
        mockNetworkService.shouldSucceed = true
        
        // When
        await viewModel.fetchHoldings()
        
        // Then
        #expect(viewModel.numberOfHoldings() == 2)
    }
    
    @Test @MainActor
    func testHoldingAtIndex_ValidIndex() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        let mockHoldings = createMockHoldings()
        mockNetworkService.mockHoldings = mockHoldings
        mockNetworkService.shouldSucceed = true
        await viewModel.fetchHoldings()
        
        // When
        let holding = viewModel.holding(at: 0)
        
        // Then
        #expect(holding != nil)
        #expect(holding?.symbol == "TCS")
        #expect(holding?.quantity == 10)
    }
    
    @Test @MainActor
    func testHoldingAtIndex_InvalidNegativeIndex() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        
        // When
        let holding = viewModel.holding(at: -1)
        
        // Then
        #expect(holding == nil)
    }
    
    @Test @MainActor
    func testHoldingAtIndex_InvalidOutOfBoundsIndex() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        let mockHoldings = createMockHoldings()
        mockNetworkService.mockHoldings = mockHoldings
        mockNetworkService.shouldSucceed = true
        await viewModel.fetchHoldings()
        
        // When
        let holding = viewModel.holding(at: 100)
        
        // Then
        #expect(holding == nil)
    }
    
    // MARK: - Portfolio Summary Calculation Tests
    
    @Test @MainActor
    func testCalculatePortfolioSummary_EmptyHoldings() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        mockNetworkService.mockHoldings = []
        mockNetworkService.shouldSucceed = true
        
        // When
        await viewModel.fetchHoldings()
        
        // Then
        guard let summary = viewModel.portfolioSummary else {
            Issue.record("Portfolio summary should exist even with empty holdings")
            return
        }
        #expect(summary.currentValue == 0.0)
        #expect(summary.totalInvestment == 0.0)
        #expect(summary.totalPnL == 0.0)
        #expect(summary.todaysPnL == 0.0)
    }
    
    @Test @MainActor
    func testCalculatePortfolioSummary_SingleHolding() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        let holding = Holding(
            symbol: "AAPL",
            quantity: 5,
            ltp: 150.0,
            avgPrice: 140.0,
            close: 155.0
        )
        mockNetworkService.mockHoldings = [holding]
        mockNetworkService.shouldSucceed = true
        
        // When
        await viewModel.fetchHoldings()
        
        // Then
        guard let summary = viewModel.portfolioSummary else {
            Issue.record("Portfolio summary should not be nil")
            return
        }
        #expect(summary.currentValue == 750.0) // 5 * 150
        #expect(summary.totalInvestment == 700.0) // 5 * 140
        #expect(summary.totalPnL == 50.0) // 750 - 700
        #expect(summary.todaysPnL == 25.0) // 5 * (155 - 150)
    }
    
    @Test @MainActor
    func testCalculatePortfolioSummary_MultipleHoldings() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = PortFolioViewModel(networkService: mockNetworkService)
        let holdings = [
            Holding(symbol: "TCS", quantity: 10, ltp: 3500.0, avgPrice: 3600.0, close: 3550.0),
            Holding(symbol: "INFY", quantity: 5, ltp: 1500.0, avgPrice: 1400.0, close: 1520.0)
        ]
        mockNetworkService.mockHoldings = holdings
        mockNetworkService.shouldSucceed = true
        
        // When
        await viewModel.fetchHoldings()
        
        // Then
        guard let summary = viewModel.portfolioSummary else {
            Issue.record("Portfolio summary should not be nil")
            return
        }
        let expectedCurrentValue = (10 * 3500.0) + (5 * 1500.0) // 35000 + 7500 = 42500
        let expectedInvestment = (10 * 3600.0) + (5 * 1400.0) // 36000 + 7000 = 43000
        let expectedTotalPnL = expectedCurrentValue - expectedInvestment // -500
        let expectedTodaysPnL = (10 * (3550.0 - 3500.0)) + (5 * (1520.0 - 1500.0)) // 500 + 100 = 600
        
        #expect(summary.currentValue == expectedCurrentValue)
        #expect(summary.totalInvestment == expectedInvestment)
        #expect(summary.totalPnL == expectedTotalPnL)
        #expect(summary.todaysPnL == expectedTodaysPnL)
    }
}

