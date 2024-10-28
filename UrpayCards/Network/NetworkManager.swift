//
//  NetworkManager.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 26/09/2024.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let baseURL: String
    
    private init(baseURL: String = "https://apigw-uat.neoleap.com.sa/nusuk-issuing") {
        self.baseURL = baseURL
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        session = URLSession(configuration: configuration)
    }
    
    // Generic request handler using JSONUtility for response parsing
    func sendRequest(
        endpoint: RequestConfig
    ) async throws -> Result<JSON, APIError> {
        
        // Construct the full URL
        guard let url = URL(string: baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        // Encode and attach the body if provided
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        print("Request: \(request)")
        
        do {
            // Send the request
            let (data, response) = try await session.data(for: request)
            
            // Validate response status
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(.invalidResponse)
            }
            
            // Use JSONUtility to parse the response data into a JSON object
            let jsonResponse = try JSON(data: data)
            return .success(jsonResponse)
            
        } catch {
            return .failure(.requestFailed(error))
        }
    }
}
