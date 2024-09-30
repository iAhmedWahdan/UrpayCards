//
//  APIEndpoint.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 26/09/2024.
//

import Foundation

struct RequestConfig {
    let method: HTTPMethod
    let path: String
    let headers: [String: String]
    let body: [String: Any]?
    
    init(method: HTTPMethod, path: String, headers: [String: String] = [:], body: [String: Any]? = nil) {
        self.method = method
        self.path = path
        self.headers = headers
        self.body = body
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case requestFailed(Error)
}
