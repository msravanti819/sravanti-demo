//
//  PortFolioNetworkManagerTests.swift
//  sravanti-demoTests
//
//  Created by Sravanti on 02/11/25.
//

import Testing
@testable import sravanti_demo

struct PortFolioNetworkManagerTests {
    
    // MARK: - URL Validation Tests
    
    @Test
    func testFetchData_WithInvalidURL() async throws {
        // Given
        let networkManager = await PortFolioNetworkManager.shared
        let invalidURL = "not a valid url"
        
        // When & Then
        await #expect(throws: NetworkError.badUrl) {
            try await networkManager.fecthData(invalidURL)
        }
    }
    
    @Test
    func testFetchData_WithEmptyURL() async throws {
        // Given
        let networkManager = await PortFolioNetworkManager.shared
        let emptyURL = ""
        
        // When & Then
        await #expect(throws: NetworkError.badUrl) {
            try await networkManager.fecthData(emptyURL)
        }
    }
    
    // MARK: - Network Error Tests
    
    @Test
    func testNetworkError_BadUrl() {
        let error = NetworkError.badUrl
        #expect(error == NetworkError.badUrl)
    }
    
    @Test
    func testNetworkError_NoData() {
        let error = NetworkError.noData
        #expect(error == NetworkError.noData)
    }
    
    // MARK: - Singleton Tests
    
    @Test
    func testNetworkManager_IsSingleton() {
        let instance1 = PortFolioNetworkManager.shared
        let instance2 = PortFolioNetworkManager.shared
        #expect(instance1 === instance2)
    }
    
    // MARK: - Protocol Conformance Tests
    
    @Test
    func testNetworkManager_ConformsToProtocol() {
        let manager = PortFolioNetworkManager.shared
        #expect(manager is NetworkServiceProtocol)
    }
}

