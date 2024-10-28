//
//  CheckCardPinRequest.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 16/10/2024.
//

import Foundation

// MARK: - CheckCardPinRequest Model
struct CheckCardPinRequest: Codable {
    let RequestHeader: RequestHeaderType
    let CheckCardPinRequestDetails: CheckCardPinRequestDetailsType
}

// CheckCardPinRequestDetails definition
struct CheckCardPinRequestDetailsType: Codable {
    let CardIdentifier: CardIdentifierType
    let KeyReference: String
    let KeyType: String
    let MessageData: String
    let Pin: String
    let PinBlockFormat: Int
    let PinType: Int
}

// MARK: - CheckCardPinResponse Model
struct CheckCardPinResponse {
    let ResponseHeader: ResponseHeaderType
}
