//
//  MockNetworkService.swift
//  sravanti-demoTests
//
//  Created by Sravanti on 02/11/25.
//

import Foundation
@testable import sravanti_demo

final class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed = true
    var mockHoldings: [Holding] = []
    var errorToThrow: Error?
    
    func fecthData(_ urlString: String) async throws -> [Holding] {
        if let error = errorToThrow {
            throw error
        }
        
        if shouldSucceed {
            return mockHoldings
        } else {
            throw NetworkError.noData
        }
    }
}

