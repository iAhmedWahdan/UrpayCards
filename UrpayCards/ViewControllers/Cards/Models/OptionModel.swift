//
//  OptionModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 03/10/2024.
//

import Foundation

// MARK: - OptionModel

struct OptionModel: Identifiable {
    let id = UUID() // Unique identifier for each option
    let title: String
    let imageName: String
    let type: OptionType
    
    // Static mock data for testing
    static func mockOptions() -> [OptionModel] {
        return [
            OptionModel(title: NSLocalizedString("Add Money", comment: ""), imageName: "ic_addMoney", type: .addMoney),
            OptionModel(title: NSLocalizedString("Card Information", comment: ""), imageName: "ic_cardInformation", type: .cardInformation),
            OptionModel(title: NSLocalizedString("Card Settings", comment: ""), imageName: "ic_cardSettings", type: .cardSettings),
            OptionModel(title: NSLocalizedString("QR Code Cash Withdrawal", comment: ""), imageName: "ic_cardQR", type: .qrCodeCashWithdrawal),
            OptionModel(title: NSLocalizedString("Card Benefits", comment: ""), imageName: "ic_cardBenefits", type: .cardBenefits)
        ]
    }
    
    enum OptionType: String, CaseIterable {
        case addMoney
        case cardInformation
        case cardSettings
        case qrCodeCashWithdrawal
        case cardBenefits
    }
}

