//
//  PaymentMethodModel.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 07/10/2024.
//

import Foundation

// MARK: - PaymentMethodModel

struct PaymentMethodModel: Identifiable {
    let id = UUID() // Unique identifier for each option
    let title: String
    let imageName: String
    let type: MethodType
    
    // Static mock data for testing
    static func mockMethods() -> [PaymentMethodModel] {
        return [
            PaymentMethodModel(title: NSLocalizedString("Bank Card", comment: ""), imageName: "ic_bankCard", type: .bankCard),
            PaymentMethodModel(title: NSLocalizedString("Account Details", comment: ""), imageName: "ic_accountDetails", type: .accountDetails),
            PaymentMethodModel(title: NSLocalizedString("ATM - Cash Deposit", comment: ""), imageName: "ic_cashDeposit", type: .cashDeposit),
            PaymentMethodModel(title: NSLocalizedString("Apple Pay", comment: ""), imageName: "ic_applePay", type: .applePay)
        ]
    }
    
    enum MethodType: String, CaseIterable {
        case bankCard
        case accountDetails
        case cashDeposit
        case applePay
    }
}
