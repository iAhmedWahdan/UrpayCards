//
//  ApplePayConfiguration.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 16/10/2024.
//

import Foundation

class ApplePayConfiguration {
    static func getConfiguration() -> (merchantId: String, currencyCode: String, countryCode: String)? {
        guard let merchantIdData = KeychainHelper.shared.load(key: "merchantId"),
              let currencyCodeData = KeychainHelper.shared.load(key: "currencyCode"),
              let countryCodeData = KeychainHelper.shared.load(key: "countryCode"),
              let merchantId = String(data: merchantIdData, encoding: .utf8),
              let currencyCode = String(data: currencyCodeData, encoding: .utf8),
              let countryCode = String(data: countryCodeData, encoding: .utf8) else {
            return nil
        }
        return (merchantId, currencyCode, countryCode)
    }
}
