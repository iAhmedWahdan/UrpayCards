//
//  CardAuthService.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 16/10/2024.
//

import Foundation

enum CardAuthService {
    
    static func updateAuthToken(request: UpdateAuthToken) async throws -> Result<UpdateAuthTokenResponse, APIError> {
        let endpoint = RequestConfig(
            method: .POST,
            path: "/oauth/token",
            headers: [
                "Authorization": "Basic NTM5MDc4NjIxYzlhNDFjOGFhMzcwMTUyOTQ2Y2FkOWE6T1RjeVlqVXpNVGN0TkRKaVl5MDBZelJpTFdGak1HVXRPRGM1TUdVeFl6QTNZbUkz"
            ],
            body: request.parameters
        )
        
        let result = try await NetworkManager.shared.sendRequest(endpoint: endpoint)
        
        // Process the result of the network call
        switch result {
        case .success(let responseJSON):
            let authResponse = UpdateAuthTokenResponse(json: responseJSON)
            return .success(authResponse)
        case .failure(let error):
            return .failure(error)
        }
    }
}
