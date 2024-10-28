//
//  CardPinUpdateRequest.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 16/10/2024.
//

import Foundation

// MARK: - SetUpdateCardPinRequest Model
struct SetUpdateCardPinRequest: Codable {
    let RequestHeader: RequestHeaderType
    let SetUpdateCardPinRequestDetails: SetUpdateCardPinRequestDetailsType
}

// SetUpdateCardPinRequestDetails definition
struct SetUpdateCardPinRequestDetailsType: Codable {
    let CardIdentifier: CardIdentifierType
    let KeyReference: String
    let KeyType: String
    let MessageData: String
    let NewCardStatus: String
    let NewPin: String
    let OldPin: String
    let PinBlockFormat: Int
    let PinType: Int
    let Reason: String
    let SkipCardStatusUpdate: Bool
    let SkipFeeCheck: Bool
}

// MARK: - SetUpdateCardPinResponse Model
struct SetUpdateCardPinResponse {
    let ResponseHeader: ResponseHeaderType
}
