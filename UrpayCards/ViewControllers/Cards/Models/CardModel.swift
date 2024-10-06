//
//  CardModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import Foundation

// MARK: - CardModel

struct CardModel: Identifiable {
    let id = UUID() // Unique identifier for each card
    let cardNumber: String
    let expiryDate: String
    let balance: Double
    
    // Static mock data for testing
    static func mockData() -> [CardModel] {
        return [
            CardModel(cardNumber: "1234 5678 9876 5432", expiryDate: "12/25", balance: 150.0),
            CardModel(cardNumber: "4321 8765 6789 1234", expiryDate: "11/26", balance: 50.0),
            CardModel(cardNumber: "5678 1234 4321 8765", expiryDate: "10/27", balance: 75.0),
            CardModel(cardNumber: "8765 4321 1234 5678", expiryDate: "09/28", balance: 200.0)
        ]
    }
}
