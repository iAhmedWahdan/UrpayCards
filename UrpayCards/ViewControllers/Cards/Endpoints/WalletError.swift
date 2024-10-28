//
//  WalletError.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 16/10/2024.
//

import Foundation

enum WalletError: Error {
    case cardAlreadyAdded
    case appleWalletUnavailable
    case initiationFailed
    case configurationMissing
    
    var localizedDescription: String {
        switch self {
        case .cardAlreadyAdded:
            return NSLocalizedString("Card is already added to Apple Wallet.", comment: "")
        case .appleWalletUnavailable:
            return NSLocalizedString("Apple Wallet is not available on this device.", comment: "")
        case .initiationFailed:
            return NSLocalizedString("Failed to initiate Apple Wallet request.", comment: "")
        case .configurationMissing:
            return NSLocalizedString("Apple Pay not configured. Please call configureApplePay before starting the session.", comment: "")
        }
    }
}
