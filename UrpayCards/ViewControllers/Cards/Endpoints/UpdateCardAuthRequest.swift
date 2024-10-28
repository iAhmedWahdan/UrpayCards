//
//  UpdateCardAuthRequest.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 16/10/2024.
//

import Foundation

struct UpdateAuthToken: Codable {
    let grant_type: String
    let client_id: String
    let client_secret: String
}

struct UpdateAuthTokenResponse {
    let access_token: String
    let expires_in: Int
    let token_type: String
    
    init(json: JSON) {
        access_token = json["access_token"].stringValue
        expires_in = json["expires_in"].intValue
        token_type = json["token_type"].stringValue
    }
}
