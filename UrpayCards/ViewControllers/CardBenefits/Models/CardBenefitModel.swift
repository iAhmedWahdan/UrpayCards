//
//  CardBenefitModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 10/10/2024.
//

import Foundation

// MARK: - CardBenefitModel

struct CardBenefitModel: Identifiable {
    let id = UUID() // Unique identifier for each card
    let title: String
    let description: String
    
    // Static mock data for testing
    static func mockData() -> [CardBenefitModel] {
        return [
            CardBenefitModel(title: "Cashback Offers", description: "Unlock a world of savings with our card's exclusive benefits: 1.5% cashback on international purchases and 1.2% on local purchases"),
            CardBenefitModel(title: "Accessible Fees", description: "Experience the luxury of our Signature card for only 300 SAR covering issuance and annual fees. Enjoy the exclusive offers, designed only for Signature cardholders"),
            CardBenefitModel(title: "Printed Copy Fees", description: "Grab your card printed copy for just 30 SAR"),
            CardBenefitModel(title: "No Withdrawals Fees", description: "Withdraw cash from any Alrajhi ATMs"),
            CardBenefitModel(title: "Cashback Offers", description: "Unlock a world of savings with our card's exclusive benefits: 1.5% cashback on international purchases and 1.2% on local purchases"),
            CardBenefitModel(title: "Accessible Fees", description: "Experience the luxury of our Signature card for only 300 SAR covering issuance and annual fees. Enjoy the exclusive offers, designed only for Signature cardholders"),
            CardBenefitModel(title: "Printed Copy Fees", description: "Grab your card printed copy for just 30 SAR"),
            CardBenefitModel(title: "No Withdrawals Fees", description: "Withdraw cash from any Alrajhi ATMs"),
            CardBenefitModel(title: "Cashback Offers", description: "Unlock a world of savings with our card's exclusive benefits: 1.5% cashback on international purchases and 1.2% on local purchases"),
            CardBenefitModel(title: "Accessible Fees", description: "Experience the luxury of our Signature card for only 300 SAR covering issuance and annual fees. Enjoy the exclusive offers, designed only for Signature cardholders"),
            CardBenefitModel(title: "Printed Copy Fees", description: "Grab your card printed copy for just 30 SAR"),
            CardBenefitModel(title: "No Withdrawals Fees", description: "Withdraw cash from any Alrajhi ATMs")
        ]
    }
}
