//
//  Network.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

enum ApiMethod: String {
    case arena = "api/arena"
    case logs = "api/logs"
    case command = "api/command"
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Network {
    private let urlSession = URLSession.shared
    let testUrlString = "https://games-test.datsteam.dev/"
    let prodUrlString = "https://games.datsteam.dev/"
    
    func sendRequest(httpMethod: HttpMethod, apiMethod: ApiMethod, bodyData: Data? = nil) async throws -> Data? {
        let url = URL(string: testUrlString + apiMethod.rawValue)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(token, forHTTPHeaderField: "X-Auth-Token")
        
        if let bodyData {
            urlRequest.httpBody = bodyData
        }
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            return data
        } catch {
            print("error: \(error)")
            throw error
        }
        
    }
}
