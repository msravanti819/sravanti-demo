//
//  PortFolioNetworkManager.swift
//  sravanti-demo
//
//  Created by Sravanti on 01/11/25.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case noData
}

// MARK: - Protocol
protocol NetworkServiceProtocol {
    func fecthData(_ urlString: String) async throws -> [Holding]
}

//MARK: - PortFolioNetworkManager
class PortFolioNetworkManager: NetworkServiceProtocol {
    static let shared = PortFolioNetworkManager()
    func fecthData(_ urlString: String) async throws -> [Holding] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            
            do {
                let decodedData = try JSONDecoder().decode(UserHoldingsResponse.self, from: data)
//                debugPrint("Successfully decoded \(decodedData.data.userHolding.count) holdings")
//                debugPrint("Holdings: \(decodedData.data.userHolding)")
                return decodedData.data.userHolding
            }
            catch let decodingError {
                
                    debugPrint("Decoding Error: \(decodingError)")
                
                //debugPrint("Decoding Error: \(decodingError)")
                throw NetworkError.noData
            }
        }
        catch {
            throw error
        }
        
    }
}
